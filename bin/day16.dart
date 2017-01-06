// Copyright (c) 2016, Christian Loitsch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';

import 'package:adventofcode2016/checksum.dart';

const seed = '10001110011110000';
const lengthA = 272;
const lengthB = 35651584;

main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  print('Day16 A.  ${calcChecksum(generateData(seed, lengthA))}');
  print('Day16 B.  ${calcChecksum(generateData(seed, lengthB))}');
}
