import 'dart:typed_data';
import 'value.dart';
import 'encode.dart';

/// Serialization exception
class SerializationException implements Exception {
  final String message;

  SerializationException(this.message);

  @override
  String toString() => 'SerializationException: $message';
}

/// Interface for objects that can be converted to NSON Value
abstract class NsonSerializable {
  /// Convert this object to NSON Value
  Value toNson();

  /// Create object from NSON Value
  /// Subclasses should implement a static fromNson method
}

/// Convert Dart object to NSON Value
Value convertToNson(Object? obj) {
  if (obj == null) {
    return Null();
  }

  // Already a NSON Value
  if (obj is Value) {
    return obj;
  }

  // NsonSerializable interface
  if (obj is NsonSerializable) {
    return obj.toNson();
  }

  // Primitive types
  if (obj is bool) {
    return Bool(obj);
  }

  if (obj is int) {
    // Default to I32 for integers (matches nson-go behavior)
    // Note: Dart's int is 64-bit on VM, 53-bit on Web
    // I32 is chosen for cross-platform compatibility and consistency with nson-go
    // Use .toI64() or .toU64() explicitly if you need 64-bit integers
    return I32(obj);
  }

  if (obj is double) {
    // Default to F64 for floating point numbers
    return F64(obj);
  }

  if (obj is String) {
    return Str(obj);
  }

  if (obj is Uint8List) {
    return Binary(obj);
  }

  if (obj is List<int>) {
    return Binary(Uint8List.fromList(obj));
  }

  // List to Array
  if (obj is List) {
    final values = obj.map((e) => convertToNson(e)).toList();
    return Array(List<Value>.from(values));
  }

  // Map to M
  if (obj is Map) {
    final nsonMap = <String, Value>{};
    for (var entry in obj.entries) {
      final key = entry.key;
      if (key is! String) {
        throw SerializationException(
          'Map keys must be strings, got ${key.runtimeType}',
        );
      }
      nsonMap[key] = convertToNson(entry.value);
    }
    return M(nsonMap);
  }

  throw SerializationException(
    'Cannot serialize type ${obj.runtimeType} to NSON',
  );
}

/// Extension to serialize Dart objects to NSON
extension NsonSerializer on Object? {
  /// Convert Dart object to NSON Value (default types: I32 for int, F64 for double)
  Value toNsonValue() => convertToNson(this);
}

/// Explicit type conversion helpers for strong typing
extension IntToNson on int {
  /// Convert to I8 (-128 to 127)
  I8 toI8() => I8(this);

  /// Convert to U8 (0 to 255)
  U8 toU8() => U8(this);

  /// Convert to I16 (-32768 to 32767)
  I16 toI16() => I16(this);

  /// Convert to U16 (0 to 65535)
  U16 toU16() => U16(this);

  /// Convert to I32 (default for int)
  I32 toI32() => I32(this);

  /// Convert to U32 (0 to 4294967295)
  U32 toU32() => U32(this);

  /// Convert to I64
  I64 toI64() => I64(this);

  /// Convert to U64
  U64 toU64() => U64(this);
}

/// Explicit type conversion helpers for double
extension DoubleToNson on double {
  /// Convert to F32 (32-bit float)
  F32 toF32() => F32(this);

  /// Convert to F64 (64-bit float, default for double)
  F64 toF64() => F64(this);
}

/// Explicit type conversion helpers for String
extension StringToNson on String {
  /// Convert to NSON String
  Str toStr() => Str(this);
}

/// Explicit type conversion helpers for bool
extension BoolToNson on bool {
  /// Convert to NSON Bool
  Bool toBool() => Bool(this);
}

/// Explicit type conversion helpers for `List<int>`
extension BytesToNson on List<int> {
  /// Convert to NSON Binary
  Binary toBinary() =>
      Binary(this is Uint8List ? this as Uint8List : Uint8List.fromList(this));
}

/// Explicit type conversion helpers for List
extension ListToNson on List {
  /// Convert to NSON Array
  Array toArray() {
    final values = map((e) => convertToNson(e)).toList();
    return Array(List<Value>.from(values));
  }
}

/// Explicit type conversion helpers for Map
extension MapToNson on Map<String, dynamic> {
  /// Convert to NSON Map
  M toNMap() {
    final nsonMap = <String, Value>{};
    for (var entry in entries) {
      nsonMap[entry.key] = convertToNson(entry.value);
    }
    return M(nsonMap);
  }
}

/// Extension to deserialize NSON Value to Dart objects
extension NsonDeserializer on Value {
  /// Convert NSON Value to Dart object
  dynamic toDartObject() {
    if (this is Null) {
      return null;
    }

    if (this is Bool) {
      return (this as Bool).value;
    }

    // All numeric types to int or double
    if (this is I8) {
      return (this as I8).value;
    }
    if (this is U8) {
      return (this as U8).value;
    }
    if (this is I16) {
      return (this as I16).value;
    }
    if (this is U16) {
      return (this as U16).value;
    }
    if (this is I32) {
      return (this as I32).value;
    }
    if (this is U32) {
      return (this as U32).value;
    }
    if (this is I64) {
      return (this as I64).value;
    }
    if (this is U64) {
      return (this as U64).value;
    }
    if (this is F32) {
      return (this as F32).value;
    }
    if (this is F64) {
      return (this as F64).value;
    }

    if (this is Str) {
      return (this as Str).value;
    }

    if (this is Binary) {
      return (this as Binary).value;
    }

    if (this is Timestamp) {
      return (this as Timestamp).value;
    }

    if (this is Id) {
      return (this as Id).value;
    }

    if (this is Array) {
      return (this as Array).map((v) => v.toDartObject()).toList();
    }

    if (this is M) {
      final map = <String, dynamic>{};
      for (var entry in (this as M).entries) {
        map[entry.key] = entry.value.toDartObject();
      }
      return map;
    }

    throw SerializationException(
      'Cannot deserialize NSON type $runtimeType to Dart object',
    );
  }

  /// Type-safe deserialization with type checking
  /// Returns the Dart object cast to type `T`
  T as<T>() {
    final obj = toDartObject();
    if (obj is T) {
      return obj;
    }
    throw SerializationException('Expected type $T but got ${obj.runtimeType}');
  }
}

/// Serialize Dart object to NSON bytes
Uint8List serialize(Object? obj) {
  return convertToNson(obj).toBytes();
}

/// Deserialize NSON bytes to Dart object
dynamic deserialize(Uint8List bytes) {
  return Value.fromBytes(bytes).toDartObject();
}

/// Deserialize NSON bytes to specific type
T deserializeAs<T>(Uint8List bytes) {
  return Value.fromBytes(bytes).as<T>();
}
