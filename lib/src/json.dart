import 'dart:convert';
import 'value.dart';

/// JSON conversion support for NSON values
/// Handles extended types like Binary, Timestamp, and Id using special markers

/// Convert NSON Value to JSON-compatible object
dynamic nsonToJson(Value value) {
  if (value is Null) {
    return null;
  }

  if (value is Bool) {
    return value.value;
  }

  if (value is F32) {
    return value.value;
  }

  if (value is F64) {
    return {'\$f64': value.value};
  }

  if (value is I32) {
    return value.value;
  }

  if (value is I64) {
    return {'\$i64': value.value};
  }

  if (value is U32) {
    return {'\$u32': value.value};
  }

  if (value is U64) {
    return {'\$u64': value.value};
  }

  if (value is I8) {
    return {'\$i8': value.value};
  }

  if (value is U8) {
    return {'\$u8': value.value};
  }

  if (value is I16) {
    return {'\$i16': value.value};
  }

  if (value is U16) {
    return {'\$u16': value.value};
  }

  if (value is Str) {
    return value.value;
  }

  if (value is Binary) {
    return {'\$bin': base64Encode(value.value)};
  }

  if (value is Timestamp) {
    return {'\$tim': value.value};
  }

  if (value is Id) {
    return {'\$mid': value.toHex()};
  }

  if (value is Array) {
    return value.map((v) => nsonToJson(v)).toList();
  }

  if (value is M) {
    final map = <String, dynamic>{};
    for (var entry in value.entries) {
      map[entry.key] = nsonToJson(entry.value);
    }
    return map;
  }

  throw Exception('Unknown NSON type: ${value.runtimeType}');
}

/// Convert JSON-compatible object to NSON Value
Value jsonToNson(dynamic json) {
  if (json == null) {
    return Null();
  }

  if (json is bool) {
    return Bool(json);
  }

  if (json is int) {
    return I32(json);
  }

  if (json is double) {
    return F32(json);
  }

  if (json is String) {
    return Str(json);
  }

  if (json is List) {
    return Array(json.map((e) => jsonToNson(e)).toList());
  }

  if (json is Map) {
    // Check for extended type markers
    if (json.length == 1) {
      final key = json.keys.first as String;
      final value = json.values.first;

      switch (key) {
        case '\$f64':
          if (value is num) {
            return F64(value.toDouble());
          }
          break;
        case '\$i64':
          if (value is int) {
            return I64(value);
          }
          break;
        case '\$u32':
          if (value is int) {
            return U32(value);
          }
          break;
        case '\$u64':
          if (value is int) {
            return U64(value);
          }
          break;
        case '\$i8':
          if (value is int) {
            return I8(value);
          }
          break;
        case '\$u8':
          if (value is int) {
            return U8(value);
          }
          break;
        case '\$i16':
          if (value is int) {
            return I16(value);
          }
          break;
        case '\$u16':
          if (value is int) {
            return U16(value);
          }
          break;
        case '\$bin':
          if (value is String) {
            try {
              return Binary(base64Decode(value));
            } catch (e) {
              // Fall through to regular map
            }
          }
          break;
        case '\$tim':
          if (value is int) {
            return Timestamp(value);
          }
          break;
        case '\$mid':
          if (value is String) {
            try {
              return Id.fromHex(value);
            } catch (e) {
              // Fall through to regular map
            }
          }
          break;
      }
    }

    // Regular map
    final nsonMap = <String, Value>{};
    for (var entry in json.entries) {
      final key = entry.key;
      if (key is! String) {
        throw Exception('Map keys must be strings');
      }
      nsonMap[key] = jsonToNson(entry.value);
    }
    return M(nsonMap);
  }

  throw Exception('Cannot convert JSON type ${json.runtimeType} to NSON');
}

/// Extension for Value to JSON conversion
extension ValueToJson on Value {
  /// Convert to JSON-compatible object
  dynamic toJson() => nsonToJson(this);

  /// Convert to JSON string
  String toJsonString({bool pretty = false}) {
    final jsonObj = toJson();
    if (pretty) {
      return const JsonEncoder.withIndent('  ').convert(jsonObj);
    }
    return jsonEncode(jsonObj);
  }

  /// Parse from JSON string
  static Value fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return jsonToNson(json);
  }
}
