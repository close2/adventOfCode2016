import 'dart:math' show Point;

const defaultPad = const ['     ', ' 123 ', ' 456 ', ' 789 ', '     '];

const diamondPad = const ['       ', '   1   ', '  234  ', ' 56789 ', '  ABC  ', '   D   ', '       '];

calcCode(String s, {List<String> pad: defaultPad}) {
  int rowWith5 = pad.indexOf(pad.firstWhere((r) => r.contains('5')));
  int posOf5InRow = pad[rowWith5].indexOf('5');

  var pos = new Point(posOf5InRow, rowWith5);

  var code = [];

  var instrs = s.split('\n').where((l) => l.isNotEmpty);
  instrs.forEach((oneNumInstr) {
    oneNumInstr.codeUnits.forEach((instr) {
      var oldPos = pos;
      switch (new String.fromCharCode(instr)) {
        case 'U':
          pos = new Point(pos.x, pos.y - 1);
          break;
        case 'D':
          pos = new Point(pos.x, pos.y + 1);
          break;
        case 'L':
          pos = new Point(pos.x - 1, pos.y);
          break;
        case 'R':
          pos = new Point(pos.x + 1, pos.y);
          break;
      }
      if (pad[pos.y][pos.x] == ' ') {
        pos = oldPos;
      }
    });
    code.add(pad[pos.y][pos.x]);
  });
  return code.join();
}
