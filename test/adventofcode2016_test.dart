// Copyright (c) 2016, Christian Loitsch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';

import 'day1.dart' as day1 show allTests;
import 'day2.dart' as day2 show allTests;
import 'day4.dart' as day4 show allTests;
import 'day6.dart' as day6 show allTests;
import 'day7.dart' as day7 show allTests;
import 'day8.dart' as day8 show allTests;
import 'day9.dart' as day9 show allTests;
import 'day10.dart' as day10 show allTests;
import 'day11.dart' as day11 show allTests;
import 'day12.dart' as day12 show allTests;
import 'day13.dart' as day13 show allTests;
import 'day14.dart' as day14 show allTests;
import 'day15.dart' as day15 show allTests;
import 'day16.dart' as day16 show allTests;
import 'day17.dart' as day17 show allTests;
import 'day18.dart' as day18 show allTests;
import 'day19.dart' as day19 show allTests;
import 'day20.dart' as day20 show allTests;
import 'day21.dart' as day21 show allTests;
import 'day22.dart' as day22 show allTests;
import 'day23.dart' as day23 show allTests;
import 'day24.dart' as day24 show allTests;

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  day1.allTests();
  day2.allTests();
  day4.allTests();
  day6.allTests();
  day7.allTests();
  day8.allTests();
  day9.allTests();
  day10.allTests();
  day11.allTests();
  day12.allTests();
  day13.allTests();
  day14.allTests();
  day15.allTests();
  day16.allTests();
  day17.allTests();
  day18.allTests();
  day19.allTests();
  day20.allTests();
  day21.allTests();
  day22.allTests();
  day23.allTests();
  day24.allTests();
}
