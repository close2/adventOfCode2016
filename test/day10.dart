import 'package:adventofcode2016/bots.dart';
import 'package:test/test.dart';

final instructions = '''
value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2
''';

void allTests() {
  test('ex1', () {
    work(instructions);
    expect(state['o0'], [5]);
    expect(state['o1'], [2]);
    expect(state['o2'], [3]);
  });
}
