// Copyright (c) 2016, Christian Loitsch. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';

import 'package:adventofcode2016/passcode.dart';

const passcode = 'qtetzkpl';

main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  print('Day17 A.  ${getPath(passcode)}');
  print('Day17 A.  ${getPath(passcode, longest: true).length}');
}
