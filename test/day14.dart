import 'package:adventofcode2016/oneTimePad.dart';
import 'package:test/test.dart';

void allTests() {
  test('ex1', () {
    expect(generateKeys('abc', 64).last, 22728);
  });
  /*
  test('ex2', () {
    expect(generateKeys('abc', 64, withKeyStretching: true).last, 22551);
  });
  */
}
