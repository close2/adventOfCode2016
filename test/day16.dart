import 'package:adventofcode2016/checksum.dart';
import 'package:test/test.dart';

void allTests() {
  test('ex1', () {
    expect(calcChecksum('110010110100'), '100');
  });
  test('ex2', () {
    expect(generateData('10000', 20), '10000011110010000111');
  });
  test('ex3', () {
    expect(calcChecksum('10000011110010000111'), '01100');
  });
}
