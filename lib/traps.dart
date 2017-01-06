class Map {
  List<List<bool>> rows = [];
  Map.fromString(String firstRow) {
    rows.add(firstRow.split('').map((c) => c == '.' ? false : true).toList(growable: false));
  }

  void addRows(int n) {
    bool isTrap(List<bool> prevRow, int pos) {
      if (pos >= 0 && pos < prevRow.length) return prevRow[pos];
      return false;
    }

    for (int i = 0; i < n; i++) {
      var prevRow = rows.last;
      var newRow = new List<bool>(prevRow.length);

      for (int pos = 0; pos < newRow.length; pos++) {
        var left = isTrap(prevRow, pos - 1);
        var center = isTrap(prevRow, pos);
        var right = isTrap(prevRow, pos + 1);
        newRow[pos] = left && center && !right ||
            !left && center && right ||
            left && !center && !right ||
            !left && !center && right;
      }
      rows.add(newRow);
    }
  }

  int countSafeTiles() {
    return rows.map((row) => row.map((tile) => tile ? 0 : 1).reduce((v1, v2) => v1 + v2)).reduce((v1, v2) => v1 + v2);
  }

  @override
  String toString() {
    return rows.map((row) => row.map((tile) => tile ? '^' : '.').join()).join('\n');
  }
}

Map buildMap(String startRow, int numRows) {
  return new Map.fromString(startRow)..addRows(numRows - 1);
}
