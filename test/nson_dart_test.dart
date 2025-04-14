import 'package:nson/nson.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final str = Str('hello');

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(str.value, 'hello');
    });
  });
}
