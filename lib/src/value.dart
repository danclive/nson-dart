import 'dart:typed_data';
import 'dart:convert';
import 'dart:collection';
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
  bool equal(Value other);

  // 抽象方法，用于计算哈希值
  int get _hash;

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
