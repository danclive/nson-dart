import 'dart:typed_data';
import 'dart:convert';
import 'package:collection/collection.dart';

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
  string(0x21),
  binary(0x22),
  array(0x31),
  map(0x32),
  timestamp(0x41),
  id(0x42);

  final int tag;
  const Type(this.tag);
}

abstract class Value {
  const Value._();

  // 抽象方法，子类必须实现，T 必须是 Value 的子类
  T get<T extends Value>();

  // 抽象 getter，子类必须实现
  Type get type;

  String get string;

  // 抽象方法，用于比较值
  bool equalsValue(Value other);

  // 类型检查方法
  bool get isF32 => type == Type.f32;
  bool get isF64 => type == Type.f64;
  bool get isI32 => type == Type.i32;
  bool get isI64 => type == Type.i64;
  bool get isU32 => type == Type.u32;
  bool get isU64 => type == Type.u64;
  bool get isString => type == Type.string;
  bool get isBinary => type == Type.binary;
  bool get isArray => type == Type.array;
  bool get isMap => type == Type.map;
  bool get isBoolean => type == Type.boolean;
  bool get isNullValue => type == Type.nullValue;
  bool get isTimestamp => type == Type.timestamp;
  bool get isId => type == Type.id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Value && type == other.type && equalsValue(other);

  @override
  int get hashCode => Object.hash(type, string);

  int get bytesSize;
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
  bool equalsValue(Value other) {
    if (other is Bool) {
      return _value == other._value;
    }
    return false;
  }

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
  bool equalsValue(Value other) {
    return other is Null;
  }

  @override
  int get bytesSize => 0;
}
