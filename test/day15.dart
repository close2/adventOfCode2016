import 'package:adventofcode2016/discs.dart';
import 'package:test/test.dart';

const discDescriptions = '''
Disc #1 has 5 positions; at time=0, it is at position 4.
Disc #2 has 2 positions; at time=0, it is at position 1.
''';

void allTests() {
  test('ex1', () {
    expect(calcPosition(discDescriptions), 5);
  });
}
