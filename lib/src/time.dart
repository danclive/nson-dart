part of 'value.dart';

class Timestamp extends Value {
  final int _value;

  Timestamp(this._value) : super._();

  int get value => _value;

  @override
  Type get type => Type.timestamp;

  @override
  T get<T extends Value>() {
    if (T == Timestamp) {
      return this as T;
    }
    throw Exception('Type mismatch: expected Timestamp but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equalsValue(Value other) {
    if (other is Timestamp) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get bytesSize => 8;
}
