import 'dart:typed_data';
import 'dart:convert';
import 'dart:collection';
import 'package:collection/collection.dart';

import 'decode.dart';

part 'num.dart';
part 'string.dart';
part 'binary.dart';
part 'array.dart';
part 'map.dart';
part 'time.dart';
part 'id.dart';

enum Type {
  boolean(0x01),
  nullValue(0x02),
  f32(0x11),
  f64(0x12),
  i32(0x13),
  i64(0x14),
  u32(0x15),
  u64(0x16),
  i8(0x17),
  u8(0x18),
  i16(0x19),
  u16(0x1A),
  string(0x21),
  binary(0x22),
  array(0x31),
  map(0x32),
  timestamp(0x41),
  id(0x42);

  final int tag;
  const Type(this.tag);

  static Type? fromTag(int tag) {
    for (var type in Type.values) {
      if (type.tag == tag) {
        return type;
      }
    }
    return null;
  }
}

abstract class Value {
  const Value._();

  // 抽象方法，子类必须实现，T 必须是 Value 的子类
  T get<T extends Value>();

  // 抽象 getter，子类必须实现
  Type get type;

  String get string;

  // 抽象方法，用于比较值
  bool equal(Value other);

  // 抽象方法，用于计算哈希值
  int get _hash;

  /// 从字节数组解析 Value
  static Value fromBytes(Uint8List bytes) {
    final reader = BytesReader(bytes);
    return reader.decodeValue();
  }

  // Type conversion helpers
  double? asF32() => this is F32 ? (this as F32).value : null;
  double? asF64() => this is F64 ? (this as F64).value : null;
  int? asI32() => this is I32 ? (this as I32).value : null;
  int? asI64() => this is I64 ? (this as I64).value : null;
  int? asU32() => this is U32 ? (this as U32).value : null;
  int? asU64() => this is U64 ? (this as U64).value : null;
  int? asI8() => this is I8 ? (this as I8).value : null;
  int? asU8() => this is U8 ? (this as U8).value : null;
  int? asI16() => this is I16 ? (this as I16).value : null;
  int? asU16() => this is U16 ? (this as U16).value : null;
  String? asString() => this is Str ? (this as Str).value : null;
  Array? asArray() => this is Array ? (this as Array) : null;
  M? asNMap() => this is M ? (this as M) : null;
  bool? asBool() => this is Bool ? (this as Bool).value : null;
  Binary? asBinary() => this is Binary ? (this as Binary) : null;
  Timestamp? asTimestamp() => this is Timestamp ? (this as Timestamp) : null;
  Id? asId() => this is Id ? (this as Id) : null;
  bool isNull() => this is Null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Value && type == other.type && equal(other);

  @override
  int get hashCode => _hash;

  int get bytesSize;

  @override
  String toString() => string;
}

class Bool extends Value {
  final bool _value;

  Bool(this._value) : super._();

  bool get value => _value;

  @override
  Type get type => Type.boolean;

  @override
  T get<T extends Value>() {
    if (T == Bool) {
      return this as T;
    }
    throw Exception('Type mismatch: expected Bool but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is Bool) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 1;
}

class Null extends Value {
  Null() : super._();

  bool get value => true;

  @override
  Type get type => Type.nullValue;

  @override
  T get<T extends Value>() {
    if (T == Null) {
      return this as T;
    }
    throw Exception('Type mismatch: expected Null but got $T');
  }

  @override
  String get string => 'null';

  @override
  bool equal(Value other) {
    return other is Null;
  }

  @override
  int get _hash => type.hashCode;

  @override
  int get bytesSize => 0;
}
