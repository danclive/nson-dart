## 1.1.0

- Added support for I8, U8, I16, U16 numeric types to match nson-rust and nson-go implementations
- Added type conversion helper methods for better type safety:
  - `asI8()`, `asU8()`, `asI16()`, `asU16()`
  - `asI32()`, `asU32()`, `asI64()`, `asU64()`
  - `asF32()`, `asF64()`
  - `asString()`, `asArray()`, `asNMap()`, `asBool()`, `asBinary()`, `asTimestamp()`, `asId()`
  - `isNull()`
- Updated Type enum with complete tag mappings (0x17-0x1A for I8, U8, I16, U16)
- Enhanced encode/decode logic to support all numeric types
- Added comprehensive test coverage for new types and helper methods
- Improved documentation with usage examples

## 1.0.0

- Initial version.
