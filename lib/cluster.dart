import 'dart:math';
import 'package:logging/logging.dart';
import 'package:collection/collection.dart';

final _logger = new Logger('cluster');

class Pc {
  final String name;
  final Point location;
  final int size;
  final int used;
  int get avail => size - used;

  Pc(this.name, this.location, this.size, this.used);

  // /dev/grid/node-x0-y0     85T   68T    17T   80%
  static var _descReg = new RegExp(r'^([^-]*-x([0-9]+)-y([0-9]+))[^0-9]+([0-9]+)T[^0-9]+([0-9]+)T');
  factory Pc.fromDesc(String pcDesc) {
    var m = _descReg.firstMatch(pcDesc);
    var name = m[1];
    var locationX = int.parse(m[2]);
    var locationY = int.parse(m[3]);
    var size = int.parse(m[4]);
    var used = int.parse(m[5]);
    return new Pc(name, new Point(locationX, locationY), size, used);
  }

  @override
  String toString() {
    return '$name, $location, size: $size, used: $used, avail: $avail';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Pc &&
        this.name == other.name &&
        this.location == other.location &&
        this.size == other.size &&
        this.used == other.used;
  }

  @override
  int get hashCode {
    return name.hashCode ^ location.hashCode ^ size.hashCode ^ used.hashCode;
  }
}

class Pair {
  final Pc n1;
  final Pc n2;

  Pair(this.n1, this.n2);
}

Iterable<Pc> _parse(String df) {
  return df.split('\n').where((s) => s.isNotEmpty && s[0] == '/').map((pcDesc) => new Pc.fromDesc(pcDesc));
}

List<Pair> findViablePairs(String df) {
  var pcs = _parse(df);
  var map = <Point, Pc>{};
  pcs.forEach((n) => map[n.location] = n);

  _logger.fine('Pcs: ${pcs.length}');
  var viablePairs = <Pair>[];
  pcs.forEach((n) {
    if (n.used == 0) return;

    pcs.where((nn) => nn != n && nn.avail >= n.used).forEach((nn) => viablePairs.add(new Pair(n, nn)));
  });

  return viablePairs;
}

class _Node implements Comparable<_Node> {
  // G cost: distance from initState
  // H cost: distance to endState
  // F cost: G + H
  final int f;
  final int g;
  final Iterable<Point> emptyMoves;

  final int h;
  final Point point;
  final _Node parent;

  _Node(this.parent, this.point, this.g, this.h, this.emptyMoves) : f = g + h;

  @override
  int compareTo(_Node other) {
    if (this.f != other.f) return this.f.compareTo(other.f);
    if (this.h != other.h) return this.h.compareTo(other.h);
    return this.hashCode.compareTo(other.hashCode);
  }
}

int _dist(Point p, [Point to = const Point(0, 0)]) {
  return (p.x - to.x).abs() + (p.y - to.y).abs();
}

Iterable<_Node> _buildEmptyPathNeighbours(_Node current, Point to, Point size, Iterable<Point> blockedPcs) {
  var x = current.point.x;
  var y = current.point.y;
  var ns = [new Point(x - 1, y), new Point(x, y - 1), new Point(x + 1, y), new Point(x, y + 1)]
      .where((p) => p.x >= 0 && p.x < size.x && p.y >= 0 && p.y < size.y).where((p) => !blockedPcs.contains(p));

  return ns.map((p) => new _Node(current, p, current.g + 1, _dist(p, to), null));
}

Iterable<Point> _moveEmpty(Point from, Point to, Point size, Iterable<Point> blockedPcs) {
  var open = new PriorityQueue<_Node>();
  var closed = new Set<Point>();
  var p2node = <Point, _Node>{};

  open.add(new _Node(null, from, 0, _dist(from), null));
  for (;;) {
    if (open.isEmpty) return null;

    var current = open.removeFirst();

    closed.add(current.point);

    if (current.point == to) {
      var runner = current;
      var path = <Point>[];
      while (runner != null && runner.parent != null) {
        path.add(runner.point);
        runner = runner.parent;
      }
      return path.reversed;
    }

    var neighbours = _buildEmptyPathNeighbours(current, to, size, blockedPcs);
    neighbours.forEach((n) {
      if (closed.contains(n.point)) return;
      var exNode = p2node[n.point];
      if (exNode != null) {
        if (exNode.f > n.f) {
          open
            ..remove(exNode)
            ..add(n);
          p2node[n.point] = n;
        }
      } else {
        open.add(n);
        p2node[n.point] = n;
      }
    });
  }
}

_Node _buildNode(_Node current, Point p, Point size, Point emptyPc, Iterable<Point> blockedPcs) {
  var moveEmptyPcPath = _moveEmpty(
      emptyPc,
      p,
      size,
      []
        ..addAll(blockedPcs)
        ..add(current.point));
  if (moveEmptyPcPath == null) return null;
  return new _Node(current, p, current.g + moveEmptyPcPath.length, _dist(p), moveEmptyPcPath);
}

Iterable<_Node> _buildNeighbours(_Node current, Point size, Point emptyPc, Iterable<Point> blockedPcs) {
  var p = current.point;
  var nPoints = [new Point(p.x - 1, p.y), new Point(p.x, p.y - 1), new Point(p.x + 1, p.y), new Point(p.x, p.y + 1)]
      .where((p) => p.x >= 0 && p.x < size.x && p.y >= 0 && p.y < size.y);
  return nPoints.map((p) => _buildNode(current, p, size, emptyPc, blockedPcs)).where((n) => n != null);
}

String _nodeToString(_Node n, Point size, Point emptyPc, Iterable<Point> blockedPcs) {
  var grid = new List<List<String>>.generate(size.y, (_) => new List<String>.generate(size.x, (_) => '.'));
  grid[0][0] = '*';
  grid[emptyPc.y][emptyPc.x] = '_';
  blockedPcs.forEach((p) => grid[p.y][p.x] = '#');
  n.emptyMoves.forEach((p) => grid[p.y][p.x] = '¤');
  grid[n.point.y][n.point.x] = 'G';

  var moved = <Iterable<Point>>[n.emptyMoves, [n.point]].expand((_) => _);
  var movedDesc = moved.map((p) => p.toString()).join(' ');
  return movedDesc + '\n' + grid.map((row) => row.join('')).join('\n');
}

List<Point> findPath(String df) {
  var pcs = _parse(df);
  var size =
      pcs.fold(new Point(1, 1), (Point p, pc) => new Point(max(p.x, pc.location.x + 1), max(p.y, pc.location.y + 1)));

  // Node 0, 0 must be movable.
  var nodeRef = pcs.firstWhere((pc) => pc.location == new Point(0, 0));

  if (nodeRef.used == 0) {
    throw new UnimplementedError('The case where Pc 0,0 is empty, is not yet implemented');
  }

  Point emptyPc = pcs.firstWhere((pc) => pc.used == 0).location;

  var blockedPcs = pcs.where((pc) => pc.used > nodeRef.size).map((pc) => pc.location);

  var startPoint = new Point(size.x - 1, 0);

  var p2node = <Point, _Node>{};
  var open = new PriorityQueue<_Node>();
  var closed = new Set<Point>();

  open.add(new _Node(null, startPoint, 0, _dist(startPoint), []));

  var target = new Point(0, 0);
  for (;;) {
    var current = open.removeFirst();
    closed.add(current.point);

    if (current.parent != null) {
      emptyPc = current.parent.point;
    }

    if (current.point == target) {
      var nodes = <_Node>[];
      var runner = current;
      while (runner != null && runner.parent != null) {
        nodes.add(runner);
        runner = runner.parent;
      }

      var points = <Point>[];
      nodes.reversed.forEach((n) {
        // TODO logging
        var emptyPc = n.parent.point;
        var movesAsString = _nodeToString(n, size, emptyPc, blockedPcs);
        _logger.finer('---\n$movesAsString\n');
        points..addAll(n.emptyMoves)..add(n.point);
      });
      return points;
    }

    var neighbours = _buildNeighbours(current, size, emptyPc, blockedPcs).where((n) => !closed.contains(n.point));
    neighbours.forEach((neighbour) {
      var exNode = p2node[neighbour.point];
      if (exNode != null) {
        if (exNode.f > neighbour.f) {
          open
            ..remove(exNode)
            ..add(neighbour);
          p2node[neighbour.point] = neighbour;
        }
      } else {
        open.add(neighbour);
        p2node[neighbour.point] = neighbour;
      }
    });
  }
}
