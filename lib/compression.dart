import 'package:logging/logging.dart';

final Logger _logger = new Logger('compression');

String decompress(String compressed) {
  _logger.fine('Looking at $compressed');
  final res = new StringBuffer();
  var prev = 0;
  int start;
  while ((start = compressed.indexOf('(', prev)) >= 0) {
    int timesPos = compressed.indexOf('x', start);
    int endMarker = compressed.indexOf(')', start);
    int length = int.parse(compressed.substring(start + 1, timesPos));
    int times = int.parse(compressed.substring(timesPos + 1, endMarker));
    _logger.fine('Found marker: $start, $endMarker, $times, $length -> ${compressed.substring(start, endMarker)}');
    var prevString = compressed.substring(prev, start);
    var stringToExp = compressed.substring(endMarker + 1, endMarker + 1 + length);
    _logger.fine('Substring prev: $prevString');
    _logger.fine('Substring exp: $stringToExp');
    res.write(prevString);
    res.write(stringToExp * times);
    prev = endMarker + 1 + length;
  }
  res.write(compressed.substring(prev));

  var resString = res.toString();
  _logger.fine('Result string: $resString');
  return resString;
}

int countDecompressed(String compressed, {int from: 0, int to: null, bool v2: false}) {
  compressed = compressed.trim();
  if (to == null) {
    to = compressed.length;
  }

  var res = 0;
  int start;
  while ((start = compressed.indexOf('(', from)) >= 0 && start < to) {
    int timesPos = compressed.indexOf('x', start);
    int endMarker = compressed.indexOf(')', start);
    int length = int.parse(compressed.substring(start + 1, timesPos));
    int times = int.parse(compressed.substring(timesPos + 1, endMarker));
    res += start - from; // string before token

    if (!v2) {
      res += times * length; // repeated text
    } else {
      res += times * countDecompressed(compressed, from: endMarker + 1, to: endMarker + length + 1, v2: true);
    }
    from = endMarker + 1 + length;
  }
  res += to - from;
  _logger.finer('returning $res');
  return res;
}

