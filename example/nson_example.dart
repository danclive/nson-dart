import 'package:nson/nson.dart';

void main() {
  var str = Str('hello');
  print('str: ${str.value}');
  print('str: ${str.type}');
  print('str: ${str.string}');
  print('str: ${str.bytesSize}');
  print('str: ${str.equalsValue(Str('hello'))}');
}
