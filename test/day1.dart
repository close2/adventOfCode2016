// Copyright (c) 2016, Christian Loitsch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:adventofcode2016/grid.dart';
import 'package:test/test.dart';

void allTests() {
  test('day1 ex1', () {
    var dist = calculateDistance('R2, L3');
    expect(dist, 5);
  });
  test('day1 ex2', () {
    var dist = calculateDistance('R2, R2, R2');
    expect(dist, 2);
  });
  test('day1 ex3', () {
    var dist = calculateDistance('R5, L5, R5, R3');
    expect(dist, 12);
  });
  test('day1 part2 ex1', () {
    var dist = calculateDistance('R8, R4, R4, R8', stopAt2ndVisit: true);
    expect(dist, 4);
  });
}
