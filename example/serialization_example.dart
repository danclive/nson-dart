import 'dart:typed_data';
import 'package:nson/nson.dart';

void main() {
  print('=== NSON Serialization Examples ===\n');

  // Example 1: Basic serialization
  basicSerialization();

  // Example 2: Strong typing with explicit conversions
  strongTyping();

  // Example 3: Complex data structures
  complexSerialization();

  // Example 4: JSON conversion
  jsonConversion();

  // Example 5: Custom serialization
  customSerialization();

  // Example 6: Id hex conversion
  idHexConversion();
}

void basicSerialization() {
  print('--- Basic Serialization (Default Types) ---');

  // int -> I32, double -> F64 by default
  final data = {'name': 'Alice', 'age': 30, 'score': 95.5, 'active': true};

  final bytes = serialize(data);
  print('Serialized ${bytes.length} bytes (age as I32, score as F64)');

  final decoded = deserialize(bytes);
  print('Decoded: $decoded');
  print('Name: ${decoded['name']}, Age: ${decoded['age']}\n');
}

void strongTyping() {
  print('--- Strong Typing with Explicit Conversions ---');

  // Use explicit type conversions for precise control
  final sensorData = M({
    'temperature': 25.toI8(), // -128 to 127
    'humidity': 65.toU8(), // 0 to 255
    'pressure': 1013.toI16(), // -32768 to 32767
    'port': 8080.toU16(), // 0 to 65535
    'timestamp': 1234567890.toI64(), // Large numbers
    'latitude': 39.9042.toF64(),
    'altitude': 30.5.toF32(),
    'name': 'Sensor-01'.toStr(),
    'active': true.toBool(),
  });

  print('Strongly-typed sensor data:');
  print('  temperature (I8): ${sensorData['temperature']?.asI8()}°C');
  print('  humidity (U8): ${sensorData['humidity']?.asU8()}%');
  print('  pressure (I16): ${sensorData['pressure']?.asI16()} hPa');
  print('  port (U16): ${sensorData['port']?.asU16()}');

  final bytes = sensorData.toBytes();
  print('Serialized ${bytes.length} bytes with precise types\n');
}

void complexSerialization() {
  print('--- Complex Data Structures ---');

  final data = {
    'user': {
      'name': 'Bob',
      'email': 'bob@example.com',
      'scores': [95.5, 87.3, 92.0],
    },
    'metadata': {'version': 1, 'timestamp': 1234567890, 'active': true},
    'tags': ['admin', 'developer', 'reviewer'],
  };

  final bytes = serialize(data);
  final decoded = deserialize(bytes);

  print('User name: ${decoded['user']['name']}');
  print('First score: ${decoded['user']['scores'][0]}');
  print('Tags: ${decoded['tags']}');
  print('Active: ${decoded['metadata']['active']}\n');
}

void jsonConversion() {
  print('--- JSON Conversion ---');

  // Create NSON value with extended types
  final nsonValue = M({
    'name': Str('Charlie'),
    'age': I32(25),
    'balance': F64(1234.56),
    'timestamp': Timestamp(1234567890),
    'binary': Binary(Uint8List.fromList([1, 2, 3, 4, 5])),
    'id': Id(Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])),
  });

  // Convert to JSON string
  print('NSON to JSON:');
  final jsonString = nsonValue.toJsonString(pretty: true);
  print(jsonString);

  // Convert back to NSON
  final decoded = ValueToJson.fromJsonString(jsonString);
  print('\nDecoded back to NSON:');
  print('Name: ${decoded.asNMap()?['name']?.asString()}');
  print('Age: ${decoded.asNMap()?['age']?.asI32()}');
  print('Timestamp: ${decoded.asNMap()?['timestamp']?.asTimestamp()?.value}');
  print('Id: ${decoded.asNMap()?['id']?.asId()?.toHex()}\n');
}

// Custom class with NSON serialization
class User implements NsonSerializable {
  final String name;
  final int age;
  final List<String> tags;

  User(this.name, this.age, this.tags);

  @override
  Value toNson() {
    return M({
      'name': Str(name),
      'age': I32(age),
      'tags': Array(tags.map((t) => Str(t)).toList()),
    });
  }

  static User fromNson(Value value) {
    final map = value.asNMap();
    if (map == null) {
      throw Exception('Expected Map value');
    }

    return User(
      map['name']?.asString() ?? '',
      map['age']?.asI32() ?? 0,
      map['tags']?.asArray()?.map((v) => v.asString() ?? '').toList() ?? [],
    );
  }

  @override
  String toString() => 'User(name: $name, age: $age, tags: $tags)';
}

void customSerialization() {
  print('--- Custom Serialization ---');

  // Create user
  final user = User('David', 35, ['developer', 'architect']);
  print('Original: $user');

  // Serialize
  final nsonValue = user.toNson();
  final bytes = nsonValue.toBytes();
  print('Serialized ${bytes.length} bytes');

  // Deserialize
  final decoded = Value.fromBytes(bytes);
  final restoredUser = User.fromNson(decoded);
  print('Restored: $restoredUser\n');
}

void idHexConversion() {
  print('--- Id Hex Conversion ---');

  // Create Id from bytes
  final id1 = Id(
    Uint8List.fromList([
      0x01,
      0x23,
      0x45,
      0x67,
      0x89,
      0xAB,
      0xCD,
      0xEF,
      0x01,
      0x23,
      0x45,
      0x67,
    ]),
  );
  print('Id from bytes: ${id1.toHex()}');

  // Create Id from hex string
  final id2 = Id.fromHex('0123456789abcdef01234567');
  print('Id from hex: ${id2.toHex()}');

  // Verify equality
  print('Ids equal: ${id1 == id2}');

  // Use in JSON
  final data = M({'userId': id1});
  final json = data.toJson();
  print('JSON representation: $json\n');
}
