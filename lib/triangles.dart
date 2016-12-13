bool isValidTriangle(List<int> sides) {
  sides.sort();
  return sides[0] + sides[1] > sides[2];
}

num countValidTriangles(String trianglesString, {bool byColumns: false}) {
  var triangles = trianglesString
      .split('\n')
      .where((s) => s.isNotEmpty)
      .map((row) => row.split(' ').where((s) => s.isNotEmpty).map(int.parse).toList(growable: false))
      .toList(growable: false);
  if (byColumns) {
    var origTri = triangles;
    triangles = <List<int>>[];
    for (int i = 0; i < origTri.length; i += 3) {
      for (int j = 0; j < 3; j++) {
        triangles.add([origTri[i][j], origTri[i + 1][j], origTri[i + 2][j]]);
      }
    }
  }

  return triangles.where(isValidTriangle).length;
}
