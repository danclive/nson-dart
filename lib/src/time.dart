part of 'value.dart';

class Timestamp extends Value {
  final int _value;

  Timestamp(this._value) : super._();

  int get value => _value;

  @override
  Type get type => Type.timestamp;

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is Timestamp) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 8;
}
