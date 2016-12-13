void rect(List<List<bool>> lcd, int x, int y) {
  for (int i = 0; i < x; i++) {
    for (int j = 0; j < y; j++) {
      lcd[j][i] = true;
    }
  }
}

void rotateRow(List<List<bool>> lcd, int row, int by) {
  final rowPixels = lcd[row];
  final l = rowPixels.length;
  var last = rowPixels[l - 1];
  var lastPixels = rowPixels.sublist(l - by);
  rowPixels.insertAll(0, lastPixels);
  rowPixels.removeRange(l, rowPixels.length);
}

void rotateColumn(List<List<bool>> lcd, int column, int by) {
  for (int i = 0; i < by; i++) {
    var prev = lcd.last[column];
    lcd.forEach((row) {
      var tmp = row[column];
      row[column] = prev;
      prev = tmp;
    });
  }
}

List<List<bool>> pixels(String commandsStrings, {int width: 50, int height: 6}) {
  List<List<bool>> lcd = new List.generate(height, (_) => new List.filled(width, false, growable: true));

  commandsStrings.split('\n').where((s) => s.isNotEmpty).forEach((command) {
    var commandSplit = command.split(' ');
    if (commandSplit[0] == 'rect') {
      var area = commandSplit[1].split('x');
      rect(lcd, int.parse(area[0]), int.parse(area[1]));
    } else if (commandSplit[1] == 'row' || commandSplit[1] == 'column') {
      var index = int.parse(commandSplit[2].substring(2));
      var by = int.parse(commandSplit[4]);
      if (commandSplit[1] == 'row')
        rotateRow(lcd, index, by);
      else
        rotateColumn(lcd, index, by);
    } else {
      print('Unknown command: $command');
    }
  });
  return lcd;
}
