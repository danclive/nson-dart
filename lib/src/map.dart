part of 'value.dart';

class M extends Value with MapMixin<String, Value> {
  final Map<String, Value> _value;

  M(this._value) : super._();

  Map<String, Value> get value => _value;

  /// 从字节数组解析 Map
  static M fromBytes(Uint8List bytes) {
    final reader = BytesReader(bytes);
    return reader.decodeMap();
  }

  @override
  Type get type => Type.map;

  @override
  String get string =>
      _value.entries.map((e) => '${e.key}: ${e.value.toString()}').join(', ');

  @override
  bool equal(Value other) {
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
  int get _hash => Object.hash(type, MapEquality().hash(_value));

  @override
  int get bytesSize {
    // 4 bytes for total length + entries + 1 byte for terminator
    int size = 4 + 1;
    for (var entry in _value.entries) {
      // key: 1 byte length + key bytes
      size += 1 + utf8.encode(entry.key).length;
      // value: 1 byte type tag + value bytes
      size += 1 + entry.value.bytesSize;
    }
    return size;
  }

  // 实现 MapMixin 所需的方法
  @override
  Value? operator [](Object? key) => _value[key];

  @override
  void operator []=(String key, Value value) => _value[key] = value;

  @override
  void clear() => _value.clear();

  @override
  Iterable<String> get keys => _value.keys;

  @override
  Value? remove(Object? key) => _value.remove(key);
}
