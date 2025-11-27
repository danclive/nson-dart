part of 'value.dart';

class Str extends Value implements Comparable<String> {
  final String _value;

  Str(this._value) : super._();

  String get value => _value;

  @override
  Type get type => Type.string;

  @override
  String get string => _value;

  @override
  bool equal(Value other) {
    if (other is Str) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => _value.hashCode;

  @override
  int get bytesSize => 4 + utf8.encode(_value).length;

  // String 方法委托
  @override
  int compareTo(String other) => _value.compareTo(other);

  // 实现 String 的常用方法
  bool contains(Pattern pattern, [int startIndex = 0]) =>
      _value.contains(pattern, startIndex);

  bool endsWith(String suffix) => _value.endsWith(suffix);

  bool startsWith(Pattern pattern, [int index = 0]) =>
      _value.startsWith(pattern, index);

  int indexOf(Pattern pattern, [int start = 0]) =>
      _value.indexOf(pattern, start);

  int lastIndexOf(Pattern pattern, [int? start]) =>
      _value.lastIndexOf(pattern, start);

  bool get isEmpty => _value.isEmpty;

  bool get isNotEmpty => _value.isNotEmpty;

  int get length => _value.length;

  String padLeft(int width, [String padding = ' ']) =>
      _value.padLeft(width, padding);

  String padRight(int width, [String padding = ' ']) =>
      _value.padRight(width, padding);

  String replaceAll(Pattern from, String replace) =>
      _value.replaceAll(from, replace);

  String replaceFirst(Pattern from, String to, [int startIndex = 0]) =>
      _value.replaceFirst(from, to, startIndex);

  List<String> split(Pattern pattern) => _value.split(pattern);

  String substring(int startIndex, [int? endIndex]) =>
      _value.substring(startIndex, endIndex);

  String toLowerCase() => _value.toLowerCase();

  String toUpperCase() => _value.toUpperCase();

  String trim() => _value.trim();

  String trimLeft() => _value.trimLeft();

  String trimRight() => _value.trimRight();

  // 操作符重载
  String operator +(String other) => _value + other;

  String operator *(int times) => _value * times;
}
