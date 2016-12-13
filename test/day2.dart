import 'package:adventofcode2016/numpad.dart';
import 'package:test/test.dart';

void allTests() {
  test('day2 ex1', () {
    expect(calcCode('ULL\nRRDDD\nLURDL\nUUUUD'), '1985');
  });
  test('day2 B ex1', () {
    expect(calcCode('ULL\nRRDDD\nLURDL\nUUUUD', pad: diamondPad), '5DB3');
  });
}

