import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'dart:convert' show UTF8;

final _logger = new Logger('oneTimePad');

Iterable<int> generateKeys(String salt, int stopAt, {bool withKeyStretching: false}) {
  final validKeyPos = <int>[];
  final keyPos = new Map<String, List<int>>();

  for (int i = 0; validKeyPos.length < stopAt; i++) {
    var key = md5.convert(UTF8.encode('$salt$i')).toString();
    if (withKeyStretching) {
      for (int j = 0; j < 2016; j++) key = md5.convert(UTF8.encode(key)).toString();
    }

    var found3Letters = false;
    int counter = 0;
    for (int pos = 1; pos < key.length; pos++) {
      if (key[pos - 1] == key[pos]) counter++;
      else counter = 0;
      if (counter == 2 && !found3Letters) {
        // Add to keyPos [key[pos]].
        keyPos[key[pos]] = (keyPos[key[pos]] ?? [])..add(i);
        found3Letters = true;
      }
      if (counter == 4) {
        _logger.info('Found 5 letter key at $i ($key)');
        // Extract all keys
        var possibleKeys = keyPos[key[pos]]; // The current i must already be in this list ⇒ != null
        validKeyPos.addAll(possibleKeys.where((keyPos) => keyPos > i - 1001 && keyPos != i));
        // Keep the current validator as possible future key.
        keyPos[key[pos]] = [i];
      }
    }
  }
  final result = (validKeyPos..sort()).take(stopAt);
  _logger.fine('Found keys at: $result');
  result.map((i) => md5.convert(UTF8.encode('$salt$i')).toString()).forEach((s) => _logger.finer('md5: $s'));
  return result;
}

