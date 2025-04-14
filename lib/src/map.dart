part of 'value.dart';

class M extends Value {
  final Map<String, Value> _value;

  M(this._value) : super._();

  Map<String, Value> get value => _value;

  @override
  Type get type => Type.map;

  @override
  T get<T extends Value>() {
    if (T == M) {
      return this as T;
    }
    throw Exception('Type mismatch: expected M but got $T');
  }

  @override
  String get string =>
      _value.entries.map((e) => '${e.key}: ${e.value.toString()}').join(', ');

  @override
  bool equalsValue(Value other) {
    if (other is M) {
      if (_value.length != other._value.length) return false;
      for (var entry in _value.entries) {
        if (!other._value.containsKey(entry.key) ||
            other._value[entry.key] != entry.value) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  @override
  int get bytesSize =>
      4 +
      1 +
      _value.values.fold(0, (sum, value) => sum + 1 + value.bytesSize + 1);
}
