part of 'value.dart';

class Array extends Value {
  final List<Value> _value;

  Array(this._value) : super._();

  List<Value> get value => _value;

  @override
  Type get type => Type.array;

  @override
  T get<T extends Value>() {
    if (T == Array) {
      return this as T;
    }
    throw Exception('Type mismatch: expected Array but got $T');
  }

  @override
  String get string => _value.map((e) => e.toString()).join(', ');

  @override
  bool equalsValue(Value other) {
    if (other is Array) {
      if (_value.length != other._value.length) return false;
      for (var i = 0; i < _value.length; i++) {
        if (_value[i] != other._value[i]) return false;
      }
      return true;
    }
    return false;
  }

  @override
  int get bytesSize =>
      4 + 1 + _value.fold(0, (sum, value) => sum + value.bytesSize + 1);
}
