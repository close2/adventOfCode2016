import 'package:logging/logging.dart';

final _logger = new Logger('rooms');

final _aCharcode = 'a'.codeUnits.first;
final _zCharcode = 'z'.codeUnits.first;
final _azLength = _zCharcode - _aCharcode + 1;

class Room {
  String complete;
  String checksum;
  String name;
  String decryptedName;
  int sectorId;
  bool valid;

  Room(this.complete) {
    var roomRegExp = new RegExp(r'^(.*)-([0-9]+)\[([a-z]*)\]$');
    var match = roomRegExp.firstMatch(complete);
    name = match[1].toLowerCase();
    sectorId = int.parse(match[2]);
    checksum = match[3];
    valid = _verifyChecksum(name, checksum);
    if (valid || checksum.isEmpty) {
      decryptedName = _decryptName(name, sectorId);
      _logger.finer('Found room: $decryptedName');
    }
  }

  static String _decryptName(String name, int sectorId) {
    var decrypted = new StringBuffer();
    for (int i = 0; i < name.length; i++) {
      var char = name[i];
      if (char == '-') {
        decrypted.write(' ');
      } else {
        var charCode = char.codeUnits.first;
        var offset = (charCode - _aCharcode + sectorId) % _azLength;
        decrypted.writeCharCode(_aCharcode + offset);
      }
    }
    return decrypted.toString();
  }

  static bool _verifyChecksum(String name, String checksum) {
    var letters = name.split('');
    var letterCounts = <String, int>{};
    letters.forEach((l) {
      if (l == '-') return;
      var currentCount = letterCounts[l] ?? 0;
      letterCounts[l] = currentCount + 1;
    });
    var correctChecksum = '';
    for (int i = 0; i < 5; i++) {
      var bestCount = 0;
      String bestLetter;
      letterCounts.forEach((l, c) {
        if (c > bestCount || c == bestCount && l.compareTo(bestLetter) < 0) {
          bestCount = c;
          bestLetter = l;
        }
      });
      correctChecksum += bestLetter;
      letterCounts[bestLetter] = -1;
    }
    _logger.fine('Comparing checksums: $correctChecksum -- $checksum');
    return correctChecksum == checksum;
  }
}


bool verifyChecksum(String completeName) {
  return new Room(completeName).valid;
}

Iterable<Room> validRooms(String allNames) {
  return allNames
      .trim()
      .split('\n')
      .map((cN) => new Room(cN))
      .where((r) => r.valid);
}

int sumOfSectorIds(String allNames) {
  return validRooms(allNames)
      .fold(0, (prev, curr) => prev + curr.sectorId);
}

Room findRoom(String allNames, String roomToFind) {
  return validRooms(allNames).where((room) => room.decryptedName.contains(roomToFind)).first;
}

