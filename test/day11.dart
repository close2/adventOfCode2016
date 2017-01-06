import 'package:adventofcode2016/microchips.dart';
import 'package:test/test.dart';

final description = '''
The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
The second floor contains a hydrogen generator.
The third floor contains a lithium generator.
The fourth floor contains nothing relevant.
''';

void allTests() {
  test('ex1', () {
    expect(calcSteps(description).length, 11);
  });
}
