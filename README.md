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

## Additional information

This package is part of the NSON family:
- [nson-rust](https://github.com/danclive/nson) - Rust implementation
- [nson-go](https://github.com/danclive/nson-go) - Go implementation

### Recent Updates

- Added support for I8, U8, I16, U16 types to match nson-rust and nson-go
- Added type conversion helper methods (asI8(), asU8(), asI16(), asU16(), etc.)
- Improved compatibility with other NSON implementations
- Added comprehensive test coverage for all data types
