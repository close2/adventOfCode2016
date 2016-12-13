import 'package:resource/resource.dart' show Resource;
import 'package:adventofcode2016/signal.dart';
import 'package:logging/logging.dart';

const inputF = 'lib/inputs/day6.txt';

main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  var resource = new Resource(inputF);
  var input = await resource.readAsString();

  print('Day6 A.  ${extractMessage(input)}');
  print('Day6 B.  ${extractMessage(input, useLeastCommon: true)}');
}
