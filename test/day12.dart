import 'package:adventofcode2016/cpu.dart';
import 'package:test/test.dart';

final instructions = '''
cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
''';

void allTests() {
  test('ex1', () {
    expect(run(instructions)['a'], 42);
  });
}
