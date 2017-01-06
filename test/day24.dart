import 'package:adventofcode2016/hvac.dart';
import 'package:test/test.dart';

final map = '''
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
''';

void allTests() {
  test('ex1', () {
    expect(findPath(map).length, 14);
  });
}
