// Copyright (c) 2016, Christian Loitsch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';

import 'day1.dart' as day1;
import 'day2.dart' as day2;
import 'day4.dart' as day4;
import 'day6.dart' as day6;
import 'day7.dart' as day7;
import 'day8.dart' as day8;
import 'day9.dart' as day9;
import 'day10.dart' as day10;

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
}
