part of 'value.dart';

class Id extends Value {
  static const int length = 12; // 固定 ID 长度为 12 字节

  final Uint8List _value;

  Id(Uint8List value)
    : _value = value.length == length ? value : _createFixedLengthId(value),
      super._();

  static Uint8List _createFixedLengthId(Uint8List value) {
    if (value.length > length) {
      // 如果长度超过12字节，截取前12字节
      return Uint8List.fromList(value.sublist(0, length));
    } else if (value.length < length) {
      // 如果长度小于12字节，填充0到12字节
      final result = Uint8List(length);
      result.setAll(0, value);
      return result;
    }
    return value;
  }

  Uint8List get value => _value;

  @override
  Type get type => Type.id;

  @override
  T get<T extends Value>() {
    if (T == Id) {
      return this as T;
    }
    throw Exception('Type mismatch: expected Id but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is Id) {
      return ListEquality().equals(_value, other._value);
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, ListEquality().hash(_value));

  @override
  int get bytesSize => length;
}
