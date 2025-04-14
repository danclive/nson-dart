part of 'value.dart';

class Array extends Value with ListMixin<Value> {
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
  bool equal(Value other) {
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
  int get _hash => Object.hash(type, ListEquality().hash(_value));

  @override
  int get bytesSize =>
      4 + 1 + _value.fold(0, (sum, value) => sum + value.bytesSize + 1);

  // 实现 ListMixin 所需的方法
  @override
  int get length => _value.length;

  @override
  set length(int newLength) => _value.length = newLength;

  @override
  Value operator [](int index) => _value[index];

  @override
  void operator []=(int index, Value value) => _value[index] = value;

  @override
  void add(Value element) => _value.add(element);

  @override
  void addAll(Iterable<Value> iterable) => _value.addAll(iterable);

  @override
  void clear() => _value.clear();

  @override
  void insert(int index, Value element) => _value.insert(index, element);

  @override
  void insertAll(int index, Iterable<Value> iterable) =>
      _value.insertAll(index, iterable);

  @override
  bool remove(Object? element) => _value.remove(element);

  @override
  Value removeAt(int index) => _value.removeAt(index);

  @override
  Value removeLast() => _value.removeLast();

  @override
  void removeRange(int start, int end) => _value.removeRange(start, end);

  @override
  void removeWhere(bool Function(Value) test) => _value.removeWhere(test);

  @override
  void replaceRange(int start, int end, Iterable<Value> newContents) =>
      _value.replaceRange(start, end, newContents);

  @override
  void retainWhere(bool Function(Value) test) => _value.retainWhere(test);
}
