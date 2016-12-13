import 'package:adventofcode2016/lcd.dart';
import 'package:test/test.dart';

List<List<bool>> _pixelsFromString(String s) {
  return s.split('\n').where((s) => s.isNotEmpty).map((s) => s.split('').map((char) => char == '#').toList()).toList();
}

const commands = const ['rect 3x2', 'rotate column x=1 by 1', 'rotate row y=0 by 4', 'rotate column x=1 by 1'];

const pixelsEx1 = '''
###....
###....
.......
''';

const pixelsEx2 = '''
#.#....
###....
.#.....
''';

const pixelsEx3 = '''
....#.#
###....
.#.....
''';

const pixelsEx4 = '''
.#..#.#
#.#....
.#.....
''';

void allTests() {
  test('ex1', () {
    expect(pixels(commands.first, width: 7, height: 3), _pixelsFromString(pixelsEx1));
  });
  test('ex2', () {
    expect(pixels(commands.take(2).join('\n'), width: 7, height: 3), _pixelsFromString(pixelsEx2));
  });
  test('ex3', () {
    expect(pixels(commands.take(3).join('\n'), width: 7, height: 3), _pixelsFromString(pixelsEx3));
  });
  test('ex4', () {
    expect(pixels(commands.take(4).join('\n'), width: 7, height: 3), _pixelsFromString(pixelsEx4));
  });
  /*
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
  */
}
