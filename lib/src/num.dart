part of 'value.dart';

class F32 extends Value {
  final double _value;

  F32(this._value) : super._();

  double get value => _value;

  @override
  Type get type => Type.f32;

  @override
  T get<T extends Value>() {
    if (T == F32) {
      return this as T;
    }
    throw Exception('Type mismatch: expected F32 but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is F32) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 4;
}

class F64 extends Value {
  final double _value;

  F64(this._value) : super._();

  double get value => _value;

  @override
  Type get type => Type.f64;

  @override
  T get<T extends Value>() {
    if (T == F64) {
      return this as T;
    }
    throw Exception('Type mismatch: expected F64 but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is F64) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 8;
}

class I32 extends Value {
  final int _value;

  I32(this._value) : super._();

  int get value => _value;

  @override
  Type get type => Type.i32;

  @override
  T get<T extends Value>() {
    if (T == I32) {
      return this as T;
    }
    throw Exception('Type mismatch: expected I32 but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is I32) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 4;
}

class I64 extends Value {
  final int _value;

  I64(this._value) : super._();

  int get value => _value;

  @override
  Type get type => Type.i64;

  @override
  T get<T extends Value>() {
    if (T == I64) {
      return this as T;
    }
    throw Exception('Type mismatch: expected I64 but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is I64) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 8;
}

class U32 extends Value {
  final int _value;

  U32(this._value) : super._();

  int get value => _value;

  @override
  Type get type => Type.u32;

  @override
  T get<T extends Value>() {
    if (T == U32) {
      return this as T;
    }
    throw Exception('Type mismatch: expected U32 but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is U32) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 4;
}

class U64 extends Value {
  final int _value;

  U64(this._value) : super._();

  int get value => _value;

  @override
  Type get type => Type.u64;

  @override
  T get<T extends Value>() {
    if (T == U64) {
      return this as T;
    }
    throw Exception('Type mismatch: expected U64 but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is U64) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 8;
}

class I8 extends Value {
  final int _value;

  I8(this._value) : super._();

  int get value => _value;

  @override
  Type get type => Type.i8;

  @override
  T get<T extends Value>() {
    if (T == I8) {
      return this as T;
    }
    throw Exception('Type mismatch: expected I8 but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is I8) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 1;
}

class U8 extends Value {
  final int _value;

  U8(this._value) : super._();

  int get value => _value;

  @override
  Type get type => Type.u8;

  @override
  T get<T extends Value>() {
    if (T == U8) {
      return this as T;
    }
    throw Exception('Type mismatch: expected U8 but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is U8) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 1;
}

class I16 extends Value {
  final int _value;

  I16(this._value) : super._();

  int get value => _value;

  @override
  Type get type => Type.i16;

  @override
  T get<T extends Value>() {
    if (T == I16) {
      return this as T;
    }
    throw Exception('Type mismatch: expected I16 but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is I16) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 2;
}

class U16 extends Value {
  final int _value;

  U16(this._value) : super._();

  int get value => _value;

  @override
  Type get type => Type.u16;

  @override
  T get<T extends Value>() {
    if (T == U16) {
      return this as T;
    }
    throw Exception('Type mismatch: expected U16 but got $T');
  }

  @override
  String get string => _value.toString();

  @override
  bool equal(Value other) {
    if (other is U16) {
      return _value == other._value;
    }
    return false;
  }

  @override
  int get _hash => Object.hash(type, _value);

  @override
  int get bytesSize => 2;
}
