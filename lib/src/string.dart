part of 'value.dart';

class Str extends Value {
  final String _value;

  Str(this._value) : super._();

  String get value => _value;

  @override
  Type get type => Type.string;

  @override
  T get<T extends Value>() {
    if (T == Str) {
      return this as T;
    }
    throw Exception('Type mismatch: expected Str but got $T');
  }

  @override
  String get string => _value;

  @override
  bool equalsValue(Value other) {
    if (other is Str) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get bytesSize => 4 + utf8.encode(_value).length;
}
