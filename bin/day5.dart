import 'dart:convert' show UTF8;
import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';


const id = 'uqwqemis';
//const id = 'abc';

main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  List<String> md5s = [];
  List<String> md5s2 = new List(8);
  int found = 0;
  for (int i = 0; found < 8; i++) {
    var md5sum = md5.convert(UTF8.encode('$id$i'));
    var md5sumS = md5sum.toString();
    if (md5sumS.startsWith('00000')) {
      if (md5s.length < 8) {
        md5s.add(md5sumS);
      }
      var pos = int.parse(md5sumS[5], onError: (_) => -1);
      if (pos >= 0 && pos < 8 && md5s2[pos] == null) {
        print('Found another md5 ($pos)');
        md5s2[pos] = md5sumS;
        found++;
      }
    }
  }
  print(md5s.map((s) => s[5]).join());
  print(md5s2.map((s) => s[6]).join());
}
