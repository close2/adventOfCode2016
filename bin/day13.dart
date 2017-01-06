// Copyright (c) 2016, Christian Loitsch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';

import 'package:adventofcode2016/maze.dart';

main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  favorite = 1364;
  start = new Point(1, 1);
  end = new Point(31, 39);
  print('Day13 A.  ${findPath().length}');
  print('Day13 B.  ${countLocations(50)}');
}
