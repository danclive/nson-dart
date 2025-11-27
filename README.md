<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# NSON Dart

A Dart implementation of NSON (Network Serialization Object Notation), a binary serialization format optimized for network transmission and IoT devices.

## Features

- **Complete Type Support**: Supports all NSON data types including:
  - Numeric types: F32, F64, I32, I64, U32, U64, I8, U8, I16, U16
  - String, Binary, Bool, Null
  - Timestamp and Id (12-byte identifier)
  - Array and Map (complex types)

- **Efficient Encoding/Decoding**: Binary format with minimal overhead
- **Type Safety**: Strong typing with type conversion helpers
- **Serialization Support**: Automatic conversion between Dart objects and NSON
- **JSON Conversion**: Convert NSON values to/from JSON with extended type support
- **Cross-Platform Compatibility**: Fully compatible with nson-rust and nson-go implementations

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  nson: ^1.0.0
```

## Usage

### Basic Types

```dart
import 'package:nson/nson.dart';

// Numeric types
final i32 = I32(42);
final u64 = U64(9223372036854775807);
final f64 = F64(3.14159);

// New 8-bit and 16-bit types
final i8 = I8(-127);
final u8 = U8(255);
final i16 = I16(-32768);
final u16 = U16(65535);

// String
final str = Str('Hello NSON');

// Boolean and Null
final boolValue = Bool(true);
final nullValue = Null();
```

### Complex Types

```dart
// Array
final array = Array([
  I32(1),
  I32(2),
  I32(3),
  Str('four'),
]);

// Map
final map = M({
  'name': Str('Alice'),
  'age': I32(30),
  'score': F64(95.5),
});
```

### Encoding and Decoding

```dart
// Encode to bytes
final value = I32(42);
final bytes = value.toBytes();

// Decode from bytes
final decoded = Value.fromBytes(bytes);
print(decoded.asI32()); // 42

// Array encoding/decoding
final array = Array([I32(1), I32(2)]);
final arrayBytes = array.toBytes();
final decodedArray = Array.fromBytes(arrayBytes);

// Map encoding/decoding
final map = M({'key': Str('value')});
final mapBytes = map.toBytes();
final decodedMap = M.fromBytes(mapBytes);
```

### Type Conversion Helpers

```dart
final value = I32(42);

// Type-safe conversion
final intValue = value.asI32(); // 42
final stringValue = value.asString(); // null (type mismatch)

// Check if null
final nullValue = Null();
print(nullValue.isNull()); // true
```

### Automatic Serialization

```dart
// Convert Dart objects to NSON (with default types)
// int -> I32, double -> F64
final data = {
  'name': 'Alice',
  'age': 30,        // I32
  'scores': [95.5, 87.3, 92.0],  // F64 values
  'active': true,
};

// Serialize to bytes
final bytes = serialize(data);

// Deserialize back to Dart object
final decoded = deserialize(bytes);
print(decoded['name']); // 'Alice'

// Type-safe deserialization
final typedMap = deserializeAs<Map<String, dynamic>>(bytes);
```

### Strong Typing with Explicit Conversions

Since Dart has unified `int` and `double` types (unlike Rust/Go), we provide explicit conversion methods for precise type control:

```dart
// Use explicit type conversions for precise control
final sensorData = M({
  'temperature': 25.toI8(),      // -128 to 127
  'humidity': 65.toU8(),          // 0 to 255
  'pressure': 1013.toI16(),       // -32768 to 32767
  'port': 8080.toU16(),           // 0 to 65535
  'timestamp': 1234567890.toI64(), // Large numbers
  'latitude': 39.9042.toF64(),    // 64-bit float
  'altitude': 30.5.toF32(),       // 32-bit float
  'name': 'Sensor-01'.toStr(),
  'active': true.toBool(),
});

// Available conversion methods:
// int:    toI8(), toU8(), toI16(), toU16(), toI32(), toU32(), toI64(), toU64()
// double: toF32(), toF64()
// String: toStr()
// bool:   toBool()
// List<int>: toBinary()
// List:   toArray()
// Map<String, dynamic>: toNMap()
```

### JSON Conversion

```dart
// NSON to JSON
final nsonValue = M({
  'name': Str('Bob'),
  'age': I32(25),
  'timestamp': Timestamp(1234567890),
});

final jsonString = nsonValue.toJsonString(pretty: true);
print(jsonString);
// Output:
// {
//   "name": "Bob",
//   "age": 25,
//   "$tim": 1234567890
// }

// JSON to NSON
final decoded = ValueToJson.fromJsonString(jsonString);
```

## Additional information

This package is part of the NSON family:
- [nson-rust](https://github.com/danclive/nson) - Rust implementation
- [nson-go](https://github.com/danclive/nson-go) - Go implementation

### Recent Updates

- **v1.1.0**: Added serialization and JSON conversion support
  - Automatic conversion between Dart objects and NSON values
  - JSON serialization with extended type support (Binary, Timestamp, Id)
  - Type-safe deserialization helpers
  - Id hex string conversion methods
- **v1.1.0**: Added I8, U8, I16, U16 types and helper methods
  - Complete numeric type support matching nson-rust and nson-go
  - Type conversion helper methods (asI8(), asU8(), etc.)
  - Comprehensive test coverage
