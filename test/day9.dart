import 'package:adventofcode2016/compression.dart';
import 'package:test/test.dart';

void allTests() {
  test('ex1', () {
    expect(countDecompressed('ADVENT'), 6);
  });
  test('ex2', () {
    expect(countDecompressed('A(1x5)BC'), 7);
  });
  test('ex3', () {
    expect(countDecompressed('(3x3)XYZ'), 9);
  });
  test('ex4', () {
    expect(countDecompressed('A(2x2)BCD(2x2)EFG'), 11);
  });
  test('ex5', () {
    expect(countDecompressed('(6x1)(1x3)A'), 6);
  });
  test('ex6', () {
    expect(countDecompressed('X(8x2)(3x3)ABCY'), 18);
  });
  test('B ex1', () {
    expect(countDecompressed('(3x3)XYZ', v2: true), 9);
  });
  test('B ex2', () {
    expect(countDecompressed('X(8x2)(3x3)ABCY', v2: true), 'XABCABCABCABCABCABCY'.length);
  });
  test('B ex3', () {
    expect(countDecompressed('(27x12)(20x12)(13x14)(7x10)(1x12)A', v2: true), 241920);
  });
  test('B ex4', () {
    expect(countDecompressed('(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN', v2: true), 445);
  });
}
