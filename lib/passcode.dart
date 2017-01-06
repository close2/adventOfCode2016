import 'dart:math';
import 'dart:convert' show UTF8;
import 'package:crypto/crypto.dart' show md5;
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

final _logger = new Logger('passcode');

class _State {
  final Point location;
  final String path;

  _State(this.location, this.path);

  @override
  String toString() {
    return '$location via $path';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is _State &&
        this.location == other.location &&
        this.path == other.path;
  }

  @override
  int get hashCode {
    return location.hashCode ^ path.hashCode;
  }
}

class _Node implements Comparable<_Node>{
  final int g;
  final int h;
  final int f;

  final _Node parent;

  final _State state;

  _Node(this.state, this.parent, this.g, this.h) : this.f = g + h;

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
    var pathComp = state.path.compareTo(other.state.path);
    if (pathComp != 0) {
      return pathComp;
    }
    return hashCode - other.hashCode;
  }
}

const endPoint = const Point(3, 3);
int _distanceToEnd(_State s) {
  return (s.location.x - endPoint.x).abs() + (s.location.y - endPoint.y).abs();
}

const bounds = const Point(4, 4);

List<_State> _findNeighbours(_Node currentNode, String passcode) {
  var currentState = currentNode.state;
  var result = <_State>[];

  var p = currentState.location;
  var hash = md5.convert(UTF8.encode('$passcode${currentState.path}')).toString();

  final openDoorReg = new RegExp(r'[b-f]');

  if (p.y > 0 && hash[0].contains(openDoorReg)) {
    result.add(new _State(new Point(p.x, p.y - 1), currentState.path + 'U'));
  }
  if (p.y < bounds.y - 1 && hash[1].contains(openDoorReg)) {
    result.add(new _State(new Point(p.x, p.y + 1), currentState.path + 'D'));
  }
  if (p.x > 0 && hash[2].contains(openDoorReg)) {
    result.add(new _State(new Point(p.x - 1, p.y), currentState.path + 'L'));
  }
  if (p.x < bounds.x - 1 && hash[3].contains(openDoorReg)) {
    result.add(new _State(new Point(p.x + 1, p.y), currentState.path + 'R'));
  }
  return result;
}

String getPath(String passcode, {bool longest: false}) {
  final openNodes = new PriorityQueue<_Node>();

  final start = new _State(new Point(0, 0), '');
  final startNode = new _Node(start, null, 0, _distanceToEnd(start));
  openNodes.add(startNode);

  var longestPath = null;

  for (;;) {
    // This break is only used for longest search as we know that there must be at least one real path.
    if (openNodes.isEmpty) break;

    var currentNode = openNodes.removeFirst();
    var currentState = currentNode.state;

    if (currentState.location == endPoint) {
      if (longest) {
        longestPath = currentState.path;
        continue;  // Don't try to find neighbours.
      } else {
        return currentState.path;
      }
    }

    var neighbours = _findNeighbours(currentNode, passcode);
    neighbours.forEach((s) {
      openNodes.add(new _Node(s, currentNode, currentNode.g + 1, _distanceToEnd(s)));
    });
  }
  return longestPath;
}
