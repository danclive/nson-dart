part of 'value.dart';

class Id extends Value {
  final Uint8List _value;

  Id(this._value) : super._();

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
  bool equalsValue(Value other) {
    if (other is Id) {
      return _value.length == other._value.length &&
          ListEquality().equals(_value, other._value);
    }
    return false;
  }

  @override
  int get bytesSize => 12;
}
