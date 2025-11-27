part of 'value.dart';

class F32 extends Value {
  final double _value;

  F32(this._value) : super._();

  double get value => _value;

  @override
  Type get type => Type.f32;

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

  I32(int value) : _value = value, super._() {
    if (value < -2147483648 || value > 2147483647) {
      throw RangeError(
        'I32 value must be in range -2147483648 to 2147483647, got $value',
      );
    }
  }

  int get value => _value;

  @override
  Type get type => Type.i32;

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

  U32(int value) : _value = value, super._() {
    if (value < 0 || value > 4294967295) {
      throw RangeError(
        'U32 value must be in range 0 to 4294967295, got $value',
      );
    }
  }

  int get value => _value;

  @override
  Type get type => Type.u32;

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

  I8(int value) : _value = value, super._() {
    if (value < -128 || value > 127) {
      throw RangeError('I8 value must be in range -128 to 127, got $value');
    }
  }

  int get value => _value;

  @override
  Type get type => Type.i8;

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

  U8(int value) : _value = value, super._() {
    if (value < 0 || value > 255) {
      throw RangeError('U8 value must be in range 0 to 255, got $value');
    }
  }

  int get value => _value;

  @override
  Type get type => Type.u8;

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

  I16(int value) : _value = value, super._() {
    if (value < -32768 || value > 32767) {
      throw RangeError(
        'I16 value must be in range -32768 to 32767, got $value',
      );
    }
  }

  int get value => _value;

  @override
  Type get type => Type.i16;

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

  U16(int value) : _value = value, super._() {
    if (value < 0 || value > 65535) {
      throw RangeError('U16 value must be in range 0 to 65535, got $value');
    }
  }

  int get value => _value;

  @override
  Type get type => Type.u16;

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
