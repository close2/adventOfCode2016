// Copyright (c) 2016, Christian Loitsch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:resource/resource.dart' show Resource;

import 'package:adventofcode2016/bots.dart';

const inputA = 'lib/inputs/day10.txt';

main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  var resource = new Resource(inputA);
  var input = await resource.readAsString();

  stopAtInputs.addAll([17, 61]);
  work(input);
  print('Day10 A.  $stoppedAt');
  stopAtInputs.clear();

  work(input);
  // We assume that all bots finished
  print('Day10 B.  ${state['o0'].first * state['o1'].first * state['o2'].first}');
}
