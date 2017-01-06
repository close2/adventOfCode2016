// Copyright (c) 2016, Christian Loitsch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:resource/resource.dart' show Resource;

import 'package:adventofcode2016/cpu.dart';

const inputA = 'lib/inputs/day23.txt';

main(List<String> arguments) async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  var resource = new Resource(inputA);
  var input = await resource.readAsString();

  print('Day23 A.  ${run(input, version: 2, initValues: {'a': 7})['a']}');
  print('Day23 B.  ${run(input, version: 2, initValues: {'a': 12})['a']}');
}
