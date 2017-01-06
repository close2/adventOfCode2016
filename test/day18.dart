import 'package:adventofcode2016/traps.dart';
import 'package:test/test.dart';

const ex1Map = '''
..^^.
.^^^^
^^..^
''';

const ex2Map = '''
.^^.^.^^^^
^^^...^..^
^.^^.^.^^.
..^^...^^^
.^^^^.^^.^
^^..^.^^..
^^^^..^^^.
^..^^^^.^^
.^^^..^.^^
^^.^^^..^^
''';

void allTests() {
  test('ex1', () {
    expect(buildMap('..^^.', 3).toString(), ex1Map.trim());
  });
  test('ex2', () {
    expect(buildMap('.^^.^.^^^^', 10).toString(), ex2Map.trim());
  });
  test('ex2B', () {
    expect(buildMap('.^^.^.^^^^', 10).countSafeTiles(), 38);
  });
}
