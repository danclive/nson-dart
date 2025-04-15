import 'dart:typed_data';

import 'package:nson/nson.dart';

void main() {
  var str = Str('hello');
  print('str: ${str.value}');
  print('str: ${str.type}');
  print('str: ${str.string}');
  print('str: ${str.bytesSize}');
  print('str: ${str.equal(Str('hello'))}');

  var arr = Array([Str('hello'), Str('world')]);
  print('arr: ${arr.value}');
  print('arr: ${arr.type}');
  print('arr: ${arr.string}');
  print('arr: ${arr.bytesSize}');
  print('arr: ${arr.equal(Array([Str('hello'), Str('world')]))}');

  print(arr);

  var map = M({'hello': Str('world'), 'world': Str('hello')});
  print('map: ${map.value}');
  print('map: ${map.type}');
  print('map: ${map.string}');
  print('map: ${map.bytesSize}');
  print('map: ${map.equal(M({'hello': Str('world'), 'world': Str('hello')}))}');

  print(map);

  var map2 = M({
    'hello': Str('world'),
    'world': Str('hello'),
    'arr': Array([Str('hello'), Str('world')]),
    'map': M({'hello': Str('world'), 'world': Str('hello')}),
    'bool': Bool(true),
    'int': I32(1),
    'u32': U32(2),
    'i64': I64(3),
    'u64': U64(4),
    'f32': F32(5.6),
    'f64': F64(6.7),
    'bytes': Binary(Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])),
    'null': Null(),
  });

  print(map2);

  var bytes = map2.toBytes();
  print('bytes: $bytes');

  var map3 = M.fromBytes(bytes);
  print(map3);

  print(map2.equal(map3));
}
