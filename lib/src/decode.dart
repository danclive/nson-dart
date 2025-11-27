import 'dart:typed_data';
import 'dart:convert';

import 'value.dart';
import 'const.dart';

/// 解码异常类型
class DecodeError implements Exception {
  final String message;

  DecodeError(this.message);

  // 特定类型的错误
  static DecodeError ioError(Exception e) => DecodeError('IO错误: $e');
  static DecodeError fromUtf8Error(Exception e) => DecodeError('UTF-8解码错误: $e');
  static DecodeError unrecognizedElementType(int tag) =>
      DecodeError('未识别的元素类型: $tag');
  static DecodeError invalidLength(int len, String desc) =>
      DecodeError('无效长度 $len: $desc');
  static DecodeError unknown(String desc) => DecodeError('未知错误: $desc');

  @override
  String toString() => 'DecodeError: $message';
}

/// 读取器接口，用于抽象数据来源
abstract class Reader {
  Uint8List readExact(int length);

  int readU8() {
    final buf = readExact(1);
    return buf[0];
  }

  int readI8() {
    final buf = readExact(1);
    final data = ByteData.view(buf.buffer, buf.offsetInBytes, 1);
    return data.getInt8(0);
  }

  int readU16() {
    final buf = readExact(2);
    final data = ByteData.view(buf.buffer, buf.offsetInBytes, 2);
    return data.getUint16(0, Endian.little);
  }

  int readI16() {
    final buf = readExact(2);
    final data = ByteData.view(buf.buffer, buf.offsetInBytes, 2);
    return data.getInt16(0, Endian.little);
  }

  int readI32() {
    final buf = readExact(4);
    final data = ByteData.view(buf.buffer, buf.offsetInBytes, 4);
    return data.getInt32(0, Endian.little);
  }

  int readU32() {
    final buf = readExact(4);
    final data = ByteData.view(buf.buffer, buf.offsetInBytes, 4);
    return data.getUint32(0, Endian.little);
  }

  int readI64() {
    final buf = readExact(8);
    final data = ByteData.view(buf.buffer, buf.offsetInBytes, 8);
    return data.getInt64(0, Endian.little);
  }

  int readU64() {
    final buf = readExact(8);
    final data = ByteData.view(buf.buffer, buf.offsetInBytes, 8);
    return data.getUint64(0, Endian.little);
  }

  double readF32() {
    final buf = readExact(4);
    final data = ByteData.view(buf.buffer, buf.offsetInBytes, 4);
    return data.getFloat32(0, Endian.little);
  }

  double readF64() {
    final buf = readExact(8);
    final data = ByteData.view(buf.buffer, buf.offsetInBytes, 8);
    return data.getFloat64(0, Endian.little);
  }

  /// 读取字符串
  String readString() {
    final len = readU32();

    // 与 Rust 实现保持一致的验证
    if (len < minNsonSize - 1) {
      throw DecodeError.invalidLength(len, "字符串长度无效：应大于 ${minNsonSize - 1}");
    }

    if (len > maxNsonSize) {
      throw DecodeError.invalidLength(len, "字符串长度超过最大值 $maxNsonSize");
    }

    // 减去长度字段本身的大小
    final dataLen = len - 4;
    final buf = readExact(dataLen);

    try {
      return utf8.decode(buf);
    } catch (e) {
      throw DecodeError.fromUtf8Error(e as Exception);
    }
  }

  /// 读取二进制数据
  Binary readBinary() {
    final len = readU32();

    // 与 Rust 实现保持一致的验证
    if (len < minNsonSize - 1) {
      throw DecodeError.invalidLength(len, "二进制数据长度无效：应大于 ${minNsonSize - 1}");
    }

    if (len > maxNsonSize) {
      throw DecodeError.invalidLength(len, "二进制数据长度超过最大值 $maxNsonSize");
    }

    // 减去长度字段本身的大小
    final dataLen = len - 4;
    final data = readExact(dataLen);

    return Binary(data);
  }

  /// 解码 Array
  Array decodeArray() {
    final array = Array([]);

    final len = readU32();

    // 与 Rust 实现保持一致的验证
    if (len < minNsonSize) {
      throw DecodeError.invalidLength(len, "数组长度无效：应大于等于 $minNsonSize");
    }

    if (len > maxNsonSize) {
      throw DecodeError.invalidLength(len, "数组长度超过最大值 $maxNsonSize");
    }

    // 读取所有元素，直到遇到结束标记
    while (true) {
      final tag = readU8();
      if (tag == 0) {
        break;
      }

      final value = decodeValueWithTag(tag);
      array.value.add(value);
    }

    return array;
  }

  /// 解码 Map
  M decodeMap() {
    final map = M({});

    final len = readU32();

    // 与 Rust 实现保持一致的验证
    if (len < minNsonSize) {
      throw DecodeError.invalidLength(len, "Map长度无效：应大于等于 $minNsonSize");
    }

    if (len > maxNsonSize) {
      throw DecodeError.invalidLength(len, "Map长度超过最大值 $maxNsonSize");
    }

    // 读取所有键值对，直到遇到结束标记
    while (true) {
      final keyLen = readU8();
      if (keyLen == 0) {
        break;
      }

      // 与 Rust 实现保持一致：键长度值是实际长度+1
      final keyDataLen = keyLen - 1;
      final keyBytes = readExact(keyDataLen);

      String key;
      try {
        key = utf8.decode(keyBytes);
      } catch (e) {
        throw DecodeError.fromUtf8Error(e as Exception);
      }

      final value = decodeValue();
      map.value[key] = value;
    }

    return map;
  }

  /// 解码值
  Value decodeValue() {
    final tag = readU8();
    return decodeValueWithTag(tag);
  }

  /// 根据标签解码值
  Value decodeValueWithTag(int tag) {
    final type = Type.values.firstWhere(
      (t) => t.tag == tag,
      orElse: () => throw DecodeError.unrecognizedElementType(tag),
    );

    switch (type) {
      case Type.f32:
        return F32(readF32());
      case Type.f64:
        return F64(readF64());
      case Type.i32:
        return I32(readI32());
      case Type.i64:
        return I64(readI64());
      case Type.u32:
        return U32(readU32());
      case Type.u64:
        return U64(readU64());
      case Type.i8:
        return I8(readI8());
      case Type.u8:
        return U8(readU8());
      case Type.i16:
        return I16(readI16());
      case Type.u16:
        return U16(readU16());
      case Type.string:
        return Str(readString());
      case Type.array:
        return decodeArray();
      case Type.map:
        return decodeMap();
      case Type.binary:
        return readBinary();
      case Type.boolean:
        return Bool(readU8() != 0);
      case Type.nullValue:
        return Null();
      case Type.timestamp:
        return Timestamp(readU64());
      case Type.id:
        final buf = readExact(12);
        return Id(buf);
    }
  }
}

/// 基于字节数组的读取器实现
class BytesReader extends Reader {
  final Uint8List _bytes;
  int _position = 0;

  BytesReader(this._bytes);

  @override
  Uint8List readExact(int length) {
    if (_position + length > _bytes.length) {
      throw DecodeError.ioError(
        Exception(
          '读取超出范围：需要读取 $length 字节，但只有 ${_bytes.length - _position} 字节可用',
        ),
      );
    }

    final result = _bytes.sublist(_position, _position + length);
    _position += length;
    return result;
  }
}
