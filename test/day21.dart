import 'package:adventofcode2016/password.dart';
import 'package:test/test.dart';

const operations = '''
swap position 4 with position 0
swap letter d with letter b
reverse positions 0 through 4
rotate left 1 step
move position 1 to position 4
move position 3 to position 0
rotate based on position of letter b
rotate based on position of letter d
''';

void allTests() {
  test('ex1', () {
    expect(scramble('abcde', operations), 'decab');
  });
  test('ex1', () {
    expect(scramble(scramble('decab', operations, reverseOp: true), operations), 'decab');
  });
}
