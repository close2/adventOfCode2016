import 'package:adventofcode2016/cpu.dart';
import 'package:test/test.dart';

final instructions = '''
cpy 2 a
tgl a
tgl a
tgl a
cpy 1 a
dec a
dec a
''';

void allTests() {
  test('ex1', () {
    expect(run(instructions, initValues: {'a': 7}, version: 2)['a'], 3);
  });
}
