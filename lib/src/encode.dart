import 'dart:typed_data';
import 'dart:convert';

import 'value.dart';
import 'const.dart';

/// 编码错误类型
class EncodeError implements Exception {
  final String message;

  EncodeError(this.message);

  // 特定类型的错误
  static EncodeError ioError(Exception e) => EncodeError('IO错误: $e');
  static EncodeError invalidKeyLen(int len, String desc) =>
      EncodeError('无效键长度 $len: $desc');
  static EncodeError invalidValueLen(int len, String desc) =>
      EncodeError('无效值长度 $len: $desc');
  static EncodeError unknown(String desc) => EncodeError('未知错误: $desc');

  @override
  String toString() => 'EncodeError: $message';
}

/// 仅在 nson 包内使用的 Uint8List 扩展方法
extension _Uint8ListExtension on Uint8List {
  /// 写入一个无符号 8 位整数
  void writeU8(int value) {
    add(value);
  }

  /// 写入一个有符号 32 位整数（小端字节序）
  void writeI32(int value) {
    final bytes = Uint8List(4);
    final data = ByteData.view(bytes.buffer);
    data.setInt32(0, value, Endian.little);
    addAll(bytes);
  }

  /// 写入一个无符号 32 位整数（小端字节序）
  void writeU32(int value) {
    final bytes = Uint8List(4);
    final data = ByteData.view(bytes.buffer);
    data.setUint32(0, value, Endian.little);
    addAll(bytes);
  }

  /// 写入一个有符号 64 位整数（小端字节序）
  void writeI64(int value) {
    final bytes = Uint8List(8);
    final data = ByteData.view(bytes.buffer);
    data.setInt64(0, value, Endian.little);
    addAll(bytes);
  }

  /// 写入一个无符号 64 位整数（小端字节序）
  void writeU64(int value) {
    final bytes = Uint8List(8);
    final data = ByteData.view(bytes.buffer);
    data.setUint64(0, value, Endian.little);
    addAll(bytes);
  }

  /// 写入一个 32 位浮点数（小端字节序）
  void writeF32(double value) {
    final bytes = Uint8List(4);
    final data = ByteData.view(bytes.buffer);
    data.setFloat32(0, value, Endian.little);
    addAll(bytes);
  }

  /// 写入一个 64 位浮点数（小端字节序）
  void writeF64(double value) {
    final bytes = Uint8List(8);
    final data = ByteData.view(bytes.buffer);
    data.setFloat64(0, value, Endian.little);
    addAll(bytes);
  }

  /// 写入一个键（1字节长度 + UTF-8 编码内容）
  void writeKey(String key) {
    final bytes = utf8.encode(key);
    if (bytes.isEmpty || bytes.length >= 255) {
      throw EncodeError.invalidKeyLen(bytes.length, 'key 长度必须大于 0 且小于 255');
    }
    // 写入 key 长度（1字节）+1
    add(bytes.length + 1);
    // 写入 key 内容（UTF-8 编码）
    addAll(bytes);
  }

  /// 写入一个字符串（4字节长度 + UTF-8 编码内容）
  void writeString(String value) {
    final bytes = utf8.encode(value);

    if (bytes.length > maxNsonSize - 4) {
      throw EncodeError.invalidValueLen(
        bytes.length,
        '字符串长度必须小于 ${maxNsonSize - 4}',
      );
    }

    // 写入 4 字节的长度 (bytes.length + 4)，使用小端字节序
    writeU32(bytes.length + 4);

    // 写入 UTF-8 编码的字符串内容
    addAll(bytes);
  }

  /// 写入二进制数据（4字节长度 + 原始数据）
  void writeBinary(Binary value) {
    if (value.value.length > maxNsonSize - 4) {
      throw EncodeError.invalidValueLen(
        value.value.length,
        '二进制数据长度必须小于 ${maxNsonSize - 4}',
      );
    }

    // 写入 4 字节的长度 (value.length + 4)
    writeU32(value.value.length + 4);

    // 写入二进制数据
    addAll(value.value);
  }
}

/// 对 Array 进行编码
void encodeArray(Uint8List buffer, Array array) {
  final len = array.bytesSize;

  if (len > maxNsonSize) {
    throw EncodeError.invalidValueLen(len, '数组长度必须小于 $maxNsonSize');
  }

  // 写入数组长度（字节大小）
  buffer.writeU32(len);

  // 写入数组中的每个元素
  for (var item in array.value) {
    encodeValue(buffer, item);
  }

  // 写入结束标记（0 字节）
  buffer.writeU8(0);
}

/// 对 Map 进行编码
void encodeMap(Uint8List buffer, M map) {
  final len = map.bytesSize;

  if (len > maxNsonSize) {
    throw EncodeError.invalidValueLen(len, 'Map 长度必须小于 $maxNsonSize');
  }

  // 写入 Map 长度（字节大小）
  buffer.writeU32(len);

  // 写入 Map 中的每个键值对
  for (var entry in map.value.entries) {
    // 写入键
    buffer.writeKey(entry.key);

    // 写入值
    encodeValue(buffer, entry.value);
  }

  // 写入结束标记（0 字节）
  buffer.writeU8(0);
}

/// 对 Value 进行编码
void encodeValue(Uint8List buffer, Value value) {
  // 写入类型标记
  buffer.writeU8(value.type.tag);

  // 根据类型写入值
  switch (value.type) {
    case Type.f32:
      buffer.writeF32(value.get<F32>().value);
      break;
    case Type.f64:
      buffer.writeF64(value.get<F64>().value);
      break;
    case Type.i32:
      buffer.writeI32(value.get<I32>().value);
      break;
    case Type.i64:
      buffer.writeI64(value.get<I64>().value);
      break;
    case Type.u32:
      buffer.writeU32(value.get<U32>().value);
      break;
    case Type.u64:
      buffer.writeU64(value.get<U64>().value);
      break;
    case Type.string:
      buffer.writeString(value.get<Str>().value);
      break;
    case Type.array:
      encodeArray(buffer, value.get<Array>());
      break;
    case Type.map:
      encodeMap(buffer, value.get<M>());
      break;
    case Type.boolean:
      buffer.writeU8(value.get<Bool>().value ? 1 : 0);
      break;
    case Type.nullValue:
      // Null 类型不需要写入额外数据
      break;
    case Type.binary:
      buffer.writeBinary(value.get<Binary>());
      break;
    case Type.timestamp:
      buffer.writeU64(value.get<Timestamp>().value);
      break;
    case Type.id:
      buffer.addAll(value.get<Id>().value);
      break;
  }
}

/// Value 类的扩展方法
extension ValueToBytes on Value {
  /// 将 Value 转换为字节数组
  Uint8List toBytes() {
    final buffer = Uint8List(0);
    encodeValue(buffer, this);
    return buffer;
  }
}

/// Array 类的扩展方法
extension ArrayToBytes on Array {
  /// 将 Array 转换为字节数组
  Uint8List toBytes() {
    final len = bytesSize;

    if (len > maxNsonSize) {
      throw EncodeError.invalidValueLen(len, '数组长度必须小于 $maxNsonSize');
    }

    final buffer = Uint8List(0);
    buffer.writeU32(len);

    for (var item in value) {
      encodeValue(buffer, item);
    }

    buffer.writeU8(0);
    return buffer;
  }
}

/// Map 类的扩展方法
extension MapToBytes on M {
  /// 将 Map 转换为字节数组
  Uint8List toBytes() {
    final len = bytesSize;

    if (len > maxNsonSize) {
      throw EncodeError.invalidValueLen(len, 'Map 长度必须小于 $maxNsonSize');
    }

    final buffer = Uint8List(0);
    buffer.writeU32(len);

    for (var entry in value.entries) {
      buffer.writeKey(entry.key);
      encodeValue(buffer, entry.value);
    }

    buffer.writeU8(0);
    return buffer;
  }
}
