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
}
