import 'package:logging/logging.dart';

final _logger = new Logger('password');

void swapPos(int x, int y, List<String> s) {
  var tmp = s[x];
  s[x] = s[y];
  s[y] = tmp;
}

void swapLetter(String x, String y, List<String> s) {
  var posX = s.indexOf(x);
  var posY = s.indexOf(y);
  swapPos(posX, posY, s);
}

void rotateLeft(int n, List<String> s, bool reverse) {
  if (reverse) {
    n = -n;
  }
  n %= s.length;
  var leftPart = s.getRange(0, n).toList(growable: false);
  var rightPart = s.getRange(n, s.length).toList(growable: false);
  s.setRange(0, rightPart.length, rightPart);
  s.setRange(rightPart.length, s.length, leftPart);
}

void rotateRight(int n, List<String> s, bool reverse) {
  rotateLeft(s.length - n, s, reverse);
}

void rotateBased(String x, List<String> s, bool reverse) {
  int calcRot(int index) {
    if (index >= 4) index++;
    return index + 1;
  }

  if (reverse) {
    var indexAfterRotate = s.indexOf(x);
    int i = 0;
    while((i + calcRot(i)) % s.length != indexAfterRotate) i++;
    rotateLeft(calcRot(i), s, false);
  } else {
    rotateRight(calcRot(s.indexOf(x)), s, false);
  }
}

void reverse(int pos1, int pos2, List<String> s) {
  for (int i = 0; i < (pos2 - pos1 + 1) ~/ 2; i++) {
    swapPos(pos1 + i, pos2 - i, s);
  }
}

void move(int pos1, int pos2, List<String> s, bool reverse) {
  if (reverse) {
    var tmp = pos1;
    pos1 = pos2;
    pos2 = tmp;
  }
  var toInsert = s[pos1];
  if (pos1 < pos2) {
    for (int i = pos1; i < pos2; i++) {
      s[i] = s[i + 1];
    }
  } else {
    for (int i = pos1; i > pos2; i--) {
      s[i] = s[i - 1];
    }
  }
  s[pos2] = toInsert;
}

String scramble(String password, String operationsString, {bool reverseOp: false}) {
  _logger.fine('scramble $password, reverseOp: $reverseOp');
  var s = password.split('');
  var ops = operationsString.split('\n').where((s) => s.isNotEmpty).toList(growable: false);
  if (reverseOp) ops = ops.reversed;
  ops.forEach((op) {
    var opSplit = op.split(' ');
    _logger.finer('${s.join()} before operation: $op');
    switch('${opSplit[0]} ${opSplit[1]}') {
      case 'swap position':
        // swap position X with position Y
        // 0    1        2 3    4        5
        swapPos(int.parse(opSplit[2]), int.parse(opSplit[5]), s);
        break;
      case 'swap letter':
        // swap letter X with letter Y
        // 0    1      2 3    4      5
        swapLetter(opSplit[2], opSplit[5], s);
        break;
      case 'rotate left':
        // rotate left X steps
        // 0      1    2 3
        rotateLeft(int.parse(opSplit[2]), s, reverseOp);
        break;
      case 'rotate right':
        // rotate right X steps
        // 0      1     2 3
        rotateRight(int.parse(opSplit[2]), s, reverseOp);
        break;
      case 'rotate based':
        // rotate based on position of letter X
        // 0      1     2  3        4  5      6
        rotateBased(opSplit[6], s, reverseOp);
        break;
      case 'reverse positions':
        // reverse positions X through Y
        // 0       1         2 3       4
        reverse(int.parse(opSplit[2]), int.parse(opSplit[4]), s);
        break;
      case 'move position':
        // move position X to position Y
        // 0    1        2 3  4        5
        move(int.parse(opSplit[2]), int.parse(opSplit[5]), s, reverseOp);
        break;
      default:
        print('Unknown operation: $op');
    }
    _logger.finer('${s.join()} after operation: $op');
  });
  return s.join();
}
