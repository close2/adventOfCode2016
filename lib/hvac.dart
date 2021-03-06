import 'dart:math';
import 'package:logging/logging.dart';
import 'package:trotter/trotter.dart';
import 'package:collection/collection.dart';

final _logger = new Logger('hvac');

class _Node implements Comparable<_Node> {
  // G cost: distance from initState
  // H cost: distance to endState
  // F cost: G + H

  final int g;
  final int h;
  final int f;

  final _Node parent;

  final Point point;

  _Node(this.parent, this.point, this.g, this.h) : this.f = g + h;

  @override
  int compareTo(_Node other) {
    if (f != other.f) {
      return f.compareTo(other.f);
    }
    return this.hashCode.compareTo(other.hashCode);
  }
}

int _dist(Point from, Point to) {
  return (from.x - to.x).abs() + (from.y - to.y).abs();
}

Iterable<_Node> _buildNeighbours(_Node current, Point target, List<List<String>> map) {
  var p = current.point;
  var neighbourPoints = [
    new Point(p.x + 1, p.y),
    new Point(p.x, p.y + 1),
    new Point(p.x - 1, p.y),
    new Point(p.x, p.y - 1)
  ].where((p) => map[p.x][p.y] != '#');
  return neighbourPoints.map((p) => new _Node(current, p, current.g + 1, _dist(p, target)));
}

int _shortestPath(Point from, Point to, List<List<String>> map) {
  var closed = new Set<Point>();
  var open = new PriorityQueue<_Node>();
  var p2n = <Point, _Node>{};

  var startNode = new _Node(null, from, 0, _dist(from, to));
  open.add(startNode);
  p2n[from] = startNode;

  for (;;) {
    var current = open.removeFirst();
    var point = current.point;
    closed.add(point);

    if (point == to) {
      int counter = 0;
      for (var runner = current; runner != null && runner.parent != null; runner = runner.parent) {
        counter++;
      }
      return counter;
    }

    var neighbours = _buildNeighbours(current, to, map);
    neighbours.forEach((neighbour) {
      var exNode = p2n[neighbour.point];
      if (exNode != null) {
        if (exNode.f > neighbour.f) {
          open.remove(exNode);
          p2n[neighbour.point] = neighbour;
          open.add(neighbour);
        }
      } else {
        p2n[neighbour.point] = neighbour;
        open.add(neighbour);
      }
    });
  }
}

class _Pair {
  final Point from;
  final Point to;

  _Pair(this.from, this.to);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is _Pair &&
        this.from == other.from &&
        this.to == other.to;
  }

  @override
  int get hashCode {
    return from.hashCode ^ to.hashCode;
  }
}
int findPath(String mapDesc, {bool goHome: false}) {
  var pointsOfInterest = <Point>[];
  Point start;

  var map = mapDesc
      .split('\n')
      .where((row) => row.isNotEmpty)
      .map((row) => row.split('').toList(growable: false))
      .toList(growable: false);

  for (int x = 0; x < map.length; x++) {
    var row = map[x];
    for (int y = 0; y < row.length; y++) {
      var c = row[y];
      if (c == '0') {
        start = new Point(x, y);
      } else if (c != '.' && c != '#') {
        pointsOfInterest.add(new Point(x, y));
      }
    }
  }

  int bestPath = null;

  var partialPaths = <_Pair, int>{};

  var perms = new Permutations(pointsOfInterest.length, pointsOfInterest);
  for (int i = 0; i < perms.length; i++) {
    var perm = perms[i] as List<Point>;
    var points = [start]..addAll(perm);
    if (goHome) {
      points.add(start);
    }

    int path = 0;
    for (var p = 0; p < points.length - 1; p++) {
      var from = points[p];
      var to = points[p + 1];

      var pair = new _Pair(from, to);
      var revPair = new _Pair(to, from);

      int newPathPart = partialPaths[pair] ?? partialPaths[revPair];
      if (newPathPart == null) {
        newPathPart = _shortestPath(from, to, map);
        partialPaths[pair] = newPathPart;
      }

      if (bestPath != null && bestPath < (path + newPathPart)) {
        // Longer than bestPath, abort.
        path = 0;
        break;
      }
      path += newPathPart;
    }
    if (path > 0) {
      bestPath = path;
    }
  }

  return bestPath;
}
