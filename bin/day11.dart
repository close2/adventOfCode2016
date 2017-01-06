// Copyright (c) 2016, Christian Loitsch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:resource/resource.dart' show Resource;

import 'package:adventofcode2016/microchips.dart';

const inputFile = 'lib/inputs/day11.txt';

const addItems = '''
An elerium generator.
An elerium-compatible microchip.
A dilithium generator.
A dilithium-compatible microchip.
''';

main(List<String> arguments) async {
  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  var resource = new Resource(inputFile);
  var input = await resource.readAsString();

  print('Day11 A.  ${calcSteps(input).length}');
  print('Day11 B.  ${calcSteps(input, addItemsString: addItems).length}');
}
