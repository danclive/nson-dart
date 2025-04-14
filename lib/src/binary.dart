part of 'value.dart';

class Binary extends Value {
  final Uint8List _value;

  Binary(this._value) : super._();

  Uint8List get value => _value;

  @override
  Type get type => Type.binary;

  @override
  T get<T extends Value>() {
    if (T == Binary) {
      return this as T;
    }
    throw Exception('Type mismatch: expected Binary but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equalsValue(Value other) {
    if (other is Binary) {
      return _value.length == other._value.length &&
          ListEquality().equals(_value, other._value);
    }
    return false;
  }

  @override
  int get bytesSize => 4 + _value.length;
}
