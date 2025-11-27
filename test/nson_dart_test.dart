import 'dart:typed_data';
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

  group('Serialization tests', () {
    test('Serialize primitive types with default types', () {
      // int becomes I32 by default
      expect(42.toNsonValue(), isA<I32>());
      expect(42.toNsonValue().asI32(), 42);

      expect(true.toNsonValue(), isA<Bool>());
      expect(true.toNsonValue().asBool(), true);

      // double becomes F64 by default
      expect(3.14.toNsonValue(), isA<F64>());
      expect(3.14.toNsonValue().asF64(), 3.14);

      expect('hello'.toNsonValue(), isA<Str>());
      expect('hello'.toNsonValue().asString(), 'hello');

      expect(null.toNsonValue(), isA<Null>());
      expect(null.toNsonValue().isNull(), true);
    });

    test('Explicit type conversion for strong typing', () {
      // Explicit integer types
      expect(42.toI8(), isA<I8>());
      expect(42.toI8().value, 42);

      expect(200.toU8(), isA<U8>());
      expect(200.toU8().value, 200);

      expect(1000.toI16(), isA<I16>());
      expect(1000.toI16().value, 1000);

      expect(50000.toU16(), isA<U16>());
      expect(50000.toU16().value, 50000);

      expect(100000.toI32(), isA<I32>());
      expect(100000.toI32().value, 100000);

      expect(3000000000.toU32(), isA<U32>());
      expect(3000000000.toU32().value, 3000000000);

      expect(9223372036854775807.toI64(), isA<I64>());
      expect(9223372036854775807.toI64().value, 9223372036854775807);

      // Explicit float types
      expect(3.14.toF32(), isA<F32>());
      expect(3.14.toF64(), isA<F64>());

      // Other explicit conversions
      expect('test'.toStr(), isA<Str>());
      expect(true.toBool(), isA<Bool>());
      expect([1, 2, 3].toBinary(), isA<Binary>());
    });
    test('Serialize List to Array', () {
      final list = [1, 2, 3, 'four', true];
      final nsonValue = list.toNsonValue();

      expect(nsonValue, isA<Array>());
      final array = nsonValue as Array;
      expect(array.length, 5);
      expect(array[0].asI32(), 1); // Default int type is I32
      expect(array[3].asString(), 'four');
      expect(array[4].asBool(), true);
    });

    test('Serialize Map to M', () {
      final map = {'name': 'Alice', 'age': 30, 'score': 95.5, 'active': true};

      final nsonValue = map.toNsonValue();
      expect(nsonValue, isA<M>());

      final nsonMap = nsonValue as M;
      expect(nsonMap['name']?.asString(), 'Alice');
      expect(nsonMap['age']?.asI32(), 30); // Default int type is I32
      expect(nsonMap['score']?.asF64(), 95.5);
      expect(nsonMap['active']?.asBool(), true);
    });

    test('Explicit typed Map', () {
      final map = M({
        'name': 'Alice'.toStr(),
        'age': 30.toI8(), // Explicitly use I8
        'score': 95.5.toF64(),
        'active': true.toBool(),
      });

      expect(map['name'], isA<Str>());
      expect(map['age'], isA<I8>());
      expect(map['age']?.asI8(), 30);
      expect(map['score'], isA<F64>());
      expect(map['active'], isA<Bool>());
    });
    test('Serialize nested structures', () {
      final data = {
        'user': {
          'name': 'Bob',
          'scores': [100, 95, 88],
        },
        'metadata': {'version': 1, 'active': true},
      };

      final nsonValue = data.toNsonValue();
      expect(nsonValue, isA<M>());

      // Round-trip test
      final bytes = serialize(data);
      final decoded = deserialize(bytes);

      expect(decoded['user']['name'], 'Bob');
      expect(decoded['user']['scores'][0], 100);
      expect(decoded['metadata']['active'], true);
    });

    test('Deserialize to Dart objects', () {
      final nsonArray = Array([I32(42), Str('hello'), Bool(true), F64(3.14)]);

      final dartList = nsonArray.toDartObject();
      expect(dartList, isA<List>());
      expect(dartList[0], 42);
      expect(dartList[1], 'hello');
      expect(dartList[2], true);
      expect(dartList[3], 3.14);
    });

    test('Type-safe deserialization', () {
      final data = {'key': 'value'};
      final bytes = serialize(data);

      final decoded = deserializeAs<Map<String, dynamic>>(bytes);
      expect(decoded, isA<Map<String, dynamic>>());
      expect(decoded['key'], 'value');
    });

    test('Serialize Uint8List to Binary', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final nsonValue = bytes.toNsonValue();

      expect(nsonValue, isA<Binary>());
      expect((nsonValue as Binary).value, bytes);
    });
  });

  group('JSON conversion tests', () {
    test('Basic types to JSON', () {
      expect(I32(42).toJson(), 42);
      expect(F32(3.14).toJson(), closeTo(3.14, 0.01));
      expect(Str('hello').toJson(), 'hello');
      expect(Bool(true).toJson(), true);
      expect(Null().toJson(), null);
    });

    test('Extended types to JSON', () {
      expect(F64(3.14159).toJson(), {'\$f64': 3.14159});
      expect(I64(9223372036854775807).toJson(), {'\$i64': 9223372036854775807});
      expect(U32(4294967295).toJson(), {'\$u32': 4294967295});
      expect(I8(-128).toJson(), {'\$i8': -128});
      expect(U8(255).toJson(), {'\$u8': 255});
      expect(I16(-32768).toJson(), {'\$i16': -32768});
      expect(U16(65535).toJson(), {'\$u16': 65535});
    });

    test('Binary to JSON with base64', () {
      final binary = Binary(Uint8List.fromList([1, 2, 3, 4, 5]));
      final json = binary.toJson();

      expect(json, isA<Map>());
      expect(json['\$bin'], isA<String>());
    });

    test('Timestamp to JSON', () {
      final timestamp = Timestamp(1234567890);
      expect(timestamp.toJson(), {'\$tim': 1234567890});
    });

    test('Id to JSON with hex', () {
      final id = Id(
        Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]),
      );
      final json = id.toJson();

      expect(json, isA<Map>());
      expect(json['\$mid'], isA<String>());
      expect(json['\$mid'], '0102030405060708090a0b0c');
    });

    test('Array to JSON', () {
      final array = Array([I32(1), I32(2), Str('three')]);
      expect(array.toJson(), [1, 2, 'three']);
    });

    test('Map to JSON', () {
      final map = M({'name': Str('Alice'), 'age': I32(30)});

      expect(map.toJson(), {'name': 'Alice', 'age': 30});
    });

    test('JSON to NSON basic types', () {
      expect(jsonToNson(42), isA<I32>());
      expect(jsonToNson(3.14), isA<F32>());
      expect(jsonToNson('hello'), isA<Str>());
      expect(jsonToNson(true), isA<Bool>());
      expect(jsonToNson(null), isA<Null>());
    });

    test('JSON to NSON extended types', () {
      expect(jsonToNson({'\$f64': 3.14159}), isA<F64>());
      expect(jsonToNson({'\$i64': 9223372036854775807}), isA<I64>());
      expect(jsonToNson({'\$u32': 4294967295}), isA<U32>());
      expect(jsonToNson({'\$i8': -128}), isA<I8>());
      expect(jsonToNson({'\$u8': 255}), isA<U8>());
      expect(jsonToNson({'\$i16': -32768}), isA<I16>());
      expect(jsonToNson({'\$u16': 65535}), isA<U16>());
    });

    test('JSON string round-trip', () {
      final original = M({
        'name': Str('Bob'),
        'age': I32(25),
        'score': F64(95.5),
        'active': Bool(true),
      });

      final jsonString = original.toJsonString();
      final decoded = ValueToJson.fromJsonString(jsonString);

      expect(decoded, equals(original));
    });

    test('Pretty JSON formatting', () {
      final value = M({'name': Str('Alice'), 'age': I32(30)});

      final prettyJson = value.toJsonString(pretty: true);
      expect(prettyJson.contains('\n'), true);
      expect(prettyJson.contains('  '), true);
    });
  });

  group('Id hex conversion tests', () {
    test('Id to hex string', () {
      final id = Id(
        Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]),
      );
      expect(id.toHex(), '0102030405060708090a0b0c');
    });

    test('Id from hex string', () {
      final id = Id.fromHex('0102030405060708090a0b0c');
      expect(
        id.value,
        Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]),
      );
    });

    test('Id hex round-trip', () {
      final original = Id(
        Uint8List.fromList([
          255,
          254,
          253,
          252,
          251,
          250,
          249,
          248,
          247,
          246,
          245,
          244,
        ]),
      );
      final hex = original.toHex();
      final decoded = Id.fromHex(hex);
      expect(decoded, equals(original));
    });

    test('Id string representation uses hex', () {
      final id = Id(
        Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]),
      );
      expect(id.string, '0102030405060708090a0b0c');
    });
  });

  group('Range validation tests', () {
    test('I8 range validation', () {
      expect(() => I8(-128), returnsNormally);
      expect(() => I8(127), returnsNormally);
      expect(() => I8(-129), throwsRangeError);
      expect(() => I8(128), throwsRangeError);
    });

    test('U8 range validation', () {
      expect(() => U8(0), returnsNormally);
      expect(() => U8(255), returnsNormally);
      expect(() => U8(-1), throwsRangeError);
      expect(() => U8(256), throwsRangeError);
    });

    test('I16 range validation', () {
      expect(() => I16(-32768), returnsNormally);
      expect(() => I16(32767), returnsNormally);
      expect(() => I16(-32769), throwsRangeError);
      expect(() => I16(32768), throwsRangeError);
    });

    test('U16 range validation', () {
      expect(() => U16(0), returnsNormally);
      expect(() => U16(65535), returnsNormally);
      expect(() => U16(-1), throwsRangeError);
      expect(() => U16(65536), throwsRangeError);
    });

    test('I32 range validation', () {
      expect(() => I32(-2147483648), returnsNormally);
      expect(() => I32(2147483647), returnsNormally);
      expect(() => I32(-2147483649), throwsRangeError);
      expect(() => I32(2147483648), throwsRangeError);
    });

    test('U32 range validation', () {
      expect(() => U32(0), returnsNormally);
      expect(() => U32(4294967295), returnsNormally);
      expect(() => U32(-1), throwsRangeError);
      expect(() => U32(4294967296), throwsRangeError);
    });
  });
}
