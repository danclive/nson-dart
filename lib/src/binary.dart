part of 'value.dart';

class Binary extends Value with ListMixin<int> {
  final Uint8List _value;

  Binary(this._value) : super._();

  Uint8List get value => _value;

  @override
  Type get type => Type.binary;

  @override
  String get string => 'Binary(${_value.length} bytes)';

  @override
  bool equal(Value other) {
    if (other is Binary) {
      return _value.length == other._value.length &&
          ListEquality().equals(_value, other._value);
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, ListEquality().hash(_value));

  @override
  int get bytesSize => 4 + _value.length;

  // 实现 ListMixin 所需的方法
  @override
  int get length => _value.length;

  @override
  set length(int newLength) => _value.length = newLength;

  @override
  int operator [](int index) => _value[index];

  @override
  void operator []=(int index, int value) => _value[index] = value;

  // 实现 Uint8List 的方法
  ByteBuffer get buffer => _value.buffer;

  int get elementSizeInBytes => _value.elementSizeInBytes;

  int get offsetInBytes => _value.offsetInBytes;
  @override
  Uint8List sublist(int start, [int? end]) => _value.sublist(start, end);

  @override
  void setAll(int index, Iterable<int> iterable) =>
      _value.setAll(index, iterable);

  @override
  void setRange(
    int start,
    int end,
    Iterable<int> iterable, [
    int skipCount = 0,
  ]) => _value.setRange(start, end, iterable, skipCount);
}
