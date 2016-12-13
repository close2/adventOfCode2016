// Copyright (c) 2016, Christian Loitsch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:adventofcode2016/grid.dart';
import 'package:resource/resource.dart' show Resource;

const inputA = 'lib/inputs/day1.txt';

main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  var resource = new Resource(inputA);
  var inputDay1A = await resource.readAsString();
  print('Day1 A.  ${calculateDistance(inputDay1A)}');
  print('Day1 B.  ${calculateDistance(inputDay1A, stopAt2ndVisit: true)}');
}
