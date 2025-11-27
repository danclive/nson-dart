## 1.1.1

### Bug Fixes
- **Range Validation**: Added range validation for all integer types to ensure type safety
  - I8: -128 to 127
  - U8: 0 to 255
  - I16: -32768 to 32767
  - U16: 0 to 65535
  - I32: -2147483648 to 2147483647
  - U32: 0 to 4294967295
  - I64 and U64: Full 64-bit range
- **Map bytesSize Calculation**: Fixed incorrect size calculation for Map type
  - Now correctly accounts for key length bytes and key content
  - Ensures accurate binary encoding size

### Code Quality
- Fixed all static analysis warnings
- Improved documentation comments
- Added 6 comprehensive range validation tests
- **Removed `get<T>()` method**: Replaced with direct type casting using `as` operator
  - More idiomatic Dart code
  - Better type safety with explicit casting
  - Simpler and clearer code in encode.dart

## 1.1.0

### New Features
- **Serialization Support**: Automatic conversion between Dart objects and NSON values
  - `serialize()` and `deserialize()` functions for easy data conversion
  - `toNsonValue()` extension method for Dart objects
  - `toDartObject()` method for NSON values
  - Type-safe deserialization with `deserializeAs<T>()`
  - `NsonSerializable` interface for custom serialization
  - **Strong Typing**: Explicit type conversion methods for precise control
    - Default types: `int` -> `I32`, `double` -> `F64`
    - Explicit conversions: `toI8()`, `toU8()`, `toI16()`, `toU16()`, `toI32()`, `toU32()`, `toI64()`, `toU64()`
    - Float conversions: `toF32()`, `toF64()`
    - Other conversions: `toStr()`, `toBool()`, `toBinary()`, `toArray()`, `toNMap()`

- **JSON Conversion**: Full JSON interoperability with extended type support
  - `toJson()` and `toJsonString()` methods for NSON values
  - `jsonToNson()` function to parse JSON into NSON
  - Extended type markers for Binary (`$bin`), Timestamp (`$tim`), Id (`$mid`)
  - Extended type markers for all numeric types (`$f64`, `$i64`, `$u32`, `$u64`, `$i8`, `$u8`, `$i16`, `$u16`)
  - Pretty JSON formatting support

- **Id Enhancements**: Hex string conversion for 12-byte identifiers
  - `Id.fromHex()` constructor to create Id from hex strings
  - `toHex()` method to convert Id to hex strings
  - Updated `string` getter to use hex representation

- **Additional Numeric Types**: Complete numeric type system
  - Added I8, U8, I16, U16 types to match nson-rust and nson-go implementations
  - Type conversion helper methods for all numeric types
  - Automatic type selection based on value range in serialization

- **Type Conversion Helpers**: Improved type safety
  - `asI8()`, `asU8()`, `asI16()`, `asU16()` methods
  - `asI32()`, `asU32()`, `asI64()`, `asU64()` methods
  - `asF32()`, `asF64()` methods
  - `asString()`, `asArray()`, `asNMap()`, `asBool()`, `asBinary()`, `asTimestamp()`, `asId()` methods
  - `isNull()` method

- **Enhanced Type System**
  - Updated Type enum with complete tag mappings (0x17-0x1A for I8, U8, I16, U16)
  - `Type.fromTag()` static method for type lookup
  - Enhanced encode/decode logic for all numeric types

- **Testing**: Comprehensive test coverage (36 tests)
  - Serialization and deserialization tests
  - JSON conversion tests
  - Id hex conversion tests
  - Type conversion helper tests
  - Round-trip encoding/decoding tests

### Documentation
- Updated README with serialization and JSON examples
- Added detailed API documentation
- Improved usage examples

## 1.0.0

- Initial version.
