// Copyright (c) 2016, Christian Loitsch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:resource/resource.dart' show Resource;

import 'package:adventofcode2016/lcd.dart';

const inputA = 'lib/inputs/day8.txt';

main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  var resource = new Resource(inputA);
  var input = await resource.readAsString();

  print('Day8 A.  ${pixels(input).expand((_) => _).where((p) => p).length}');
  print('Day8 B.  ${pixels(input).map((row) => print(row.map((p) => p ? '•' : ' '). join()))}');
}
