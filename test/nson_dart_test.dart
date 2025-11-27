import 'package:nson/nson.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final str = Str('hello');

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(str.value, 'hello');
    });
  });

  group('New numeric types tests', () {
    test('I8 type test', () {
      final i8 = I8(-127);
      expect(i8.value, -127);
      expect(i8.type, Type.i8);
      expect(i8.bytesSize, 1);

      // Test encoding and decoding
      final bytes = i8.toBytes();
      final decoded = Value.fromBytes(bytes);
      expect(decoded, equals(i8));
    });

    test('U8 type test', () {
      final u8 = U8(255);
      expect(u8.value, 255);
      expect(u8.type, Type.u8);
      expect(u8.bytesSize, 1);

      // Test encoding and decoding
      final bytes = u8.toBytes();
      final decoded = Value.fromBytes(bytes);
      expect(decoded, equals(u8));
    });

    test('I16 type test', () {
      final i16 = I16(-32767);
      expect(i16.value, -32767);
      expect(i16.type, Type.i16);
      expect(i16.bytesSize, 2);

      // Test encoding and decoding
      final bytes = i16.toBytes();
      final decoded = Value.fromBytes(bytes);
      expect(decoded, equals(i16));
    });

    test('U16 type test', () {
      final u16 = U16(65535);
      expect(u16.value, 65535);
      expect(u16.type, Type.u16);
      expect(u16.bytesSize, 2);

      // Test encoding and decoding
      final bytes = u16.toBytes();
      final decoded = Value.fromBytes(bytes);
      expect(decoded, equals(u16));
    });
  });

  group('Value as_* helper methods tests', () {
    test('asI8 method', () {
      final i8 = I8(-100);
      expect(i8.asI8(), -100);
      expect(i8.asI32(), null);
    });

    test('asU8 method', () {
      final u8 = U8(200);
      expect(u8.asU8(), 200);
      expect(u8.asU32(), null);
    });

    test('asI16 method', () {
      final i16 = I16(-1000);
      expect(i16.asI16(), -1000);
      expect(i16.asI64(), null);
    });

    test('asU16 method', () {
      final u16 = U16(2000);
      expect(u16.asU16(), 2000);
      expect(u16.asU64(), null);
    });

    test('asString method', () {
      final str = Str('test');
      expect(str.asString(), 'test');
      expect(str.asI32(), null);
    });

    test('asBool method', () {
      final boolTrue = Bool(true);
      expect(boolTrue.asBool(), true);
      expect(boolTrue.asString(), null);
    });

    test('isNull method', () {
      final nullValue = Null();
      expect(nullValue.isNull(), true);

      final notNull = I32(42);
      expect(notNull.isNull(), false);
    });
  });

  group('Array with new types', () {
    test('Array containing I8/U8/I16/U16', () {
      final array = Array([
        I8(-10),
        U8(200),
        I16(-1000),
        U16(5000),
        I32(100000),
      ]);

      expect(array.length, 5);
      expect(array[0].asI8(), -10);
      expect(array[1].asU8(), 200);
      expect(array[2].asI16(), -1000);
      expect(array[3].asU16(), 5000);
      expect(array[4].asI32(), 100000);

      // Test encoding and decoding
      final bytes = array.toBytes();
      final decoded = Array.fromBytes(bytes);
      expect(decoded, equals(array));
    });
  });

  group('Map with new types', () {
    test('Map containing I8/U8/I16/U16', () {
      final map = M({
        'i8': I8(-50),
        'u8': U8(150),
        'i16': I16(-5000),
        'u16': U16(30000),
      });

      expect(map['i8']?.asI8(), -50);
      expect(map['u8']?.asU8(), 150);
      expect(map['i16']?.asI16(), -5000);
      expect(map['u16']?.asU16(), 30000);

      // Test encoding and decoding
      final bytes = map.toBytes();
      final decoded = M.fromBytes(bytes);
      expect(decoded, equals(map));
    });
  });
}
