import 'dart:math';
import 'dart:collection';
import 'package:logging/logging.dart';
import 'package:collection/collection.dart';

export 'dart:math' show Point;

final _logger = new Logger('maze');

var favorite = 10;
Point start = new Point(1, 1);
Point end = new Point(7, 4);

bool isOpenSpace(Point p) {
  return _isOpenSpace(p);
}

bool _isOpenSpace(Point p) {
  if (p.x < 0 || p.y < 0) return false;

  final x = p.x;
  final y = p.y;
  int sum = x * x + 3 * x + 2 * x * y + y + y * y + favorite;
  var bits = 0;
  while (sum != 0) {
    if (sum & 1 == 1) bits++;
    sum >>= 1;
  }
  return bits.isEven;
}

class _Node implements Comparable<_Node> {
  final Point p;

  // G cost: distance from initState
  // H cost: distance to endState
  // F cost: G + H
  final int g;
  final int h;
  final int f;

  final _Node parent;

  _Node(this.p, this.parent, this.g, this.h) : this.f = g + h;

  @override
  int compareTo(_Node other) {
    var fComp = f - other.f;
    if (fComp != 0) {
      return fComp;
    }
    var hComp = h - other.h;
    if (hComp != 0) {
      return hComp;
    }
    var xComp = p.x - other.p.x;
    if (xComp != 0) {
      return xComp;
    }
    var yComp = p.y - other.p.y;
    if (yComp != 0) {
      return yComp;
    }
    return hashCode - other.hashCode;
  }

  String toString() {
    return '$p: ($f)';
  }
}

Iterable<Point> _findNeighbours(Point p) {
  return [new Point(p.x + 1, p.y), new Point(p.x, p.y + 1), new Point(p.x - 1, p.y), new Point(p.x, p.y - 1)]
      .where(_isOpenSpace);
}

int _calcManhDistanceToEnd(Point p) {
  return (end.x - p.x).abs() + (end.y - p.y).abs();
}

_Node _buildNode(_Node currentNode, Point forPoint) {
  return new _Node(forPoint, currentNode, currentNode.g + 1, _calcManhDistanceToEnd(forPoint));
}

/**
 * Either returns a path, or the visited points if abortAt has been reached.
 */
Iterable<Point> _findPath({int abortAt: null}) {
  final openNodes = new PriorityQueue<_Node>();
  final openPoints = new HashMap<Point, _Node>();
  final closedPoints = new HashSet<Point>();

  var startNode = new _Node(start, null, 0, _calcManhDistanceToEnd(start));
  openNodes.add(startNode);
  openPoints[start] = startNode;

  for (;;) {
    if (openNodes.isEmpty) break;
    var currentNode = openNodes.removeFirst();
    var currentPoint = currentNode.p;

    closedPoints.add(currentPoint);
    openPoints.remove(currentPoint);

    if (currentPoint == end) {
      var path = <Point>[];
      var runner = currentNode;
      while (runner.parent != null) {
        path.add(runner.p);
        runner = runner.parent;
      }
      return path.reversed.toList(growable: false);
    }

    if (abortAt != null && currentNode.g == abortAt) continue;

    var neighbours = _findNeighbours(currentPoint);
    neighbours.forEach((p) {
      if (closedPoints.contains(p)) return;

      var n = openPoints[p];
      var newNode = _buildNode(currentNode, p);
      if (n != null) { // We might have to update g for this point.
        if (n.f > newNode.f) {
          openPoints[p] = newNode;
          openNodes
            ..remove(n)
            ..add(newNode);
        }
      } else {
        var newNode = _buildNode(currentNode, p);
        openPoints[p] = newNode;
        openNodes.add(newNode);
      }
    });
  }
  return closedPoints;
}

Iterable<Point> findPath() {
  return _findPath();
}

int countLocations(int abortAt) {
  final backupEnd = end;
  end = new Point(start.x + abortAt + 1, start.y + abortAt + 1);
  var res = _findPath(abortAt: abortAt).length;
  end = backupEnd;
  return res;
}
