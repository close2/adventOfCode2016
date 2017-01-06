import 'dart:math';

import 'package:adventofcode2016/maze.dart';
import 'package:test/test.dart';

void allTests() {
  test('ex1', () {
    start = new Point(1, 1);
    end = new Point(7, 4);
    favorite = 10;
    expect(findPath().length, 11);
  });
}
