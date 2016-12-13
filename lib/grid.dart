import 'dart:math';
import 'package:logging/logging.dart';

final _logger = new Logger('grid');

num _distance(Point p) {
  return p.x.abs() + p.y.abs();
}

num calculateDistance(String allInstructions, {bool stopAt2ndVisit: false}) {
  Point pos = new Point(0, 0);
  var direction = 0; // 0 == North, 1 == East, 2 == South, 3 == West
  var instructions = allInstructions.split(',').map((dir) => dir.trim());

  var visitedPoints = <Point>[];

  for (var instr in instructions) {
    _logger.finer('Direction: «$instr»');
    if (instr.startsWith('R')) {
      direction = (direction + 1) % 4;
    } else {
      direction = (direction + 3) % 4;
    }
    var steps = int.parse(instr.substring(1));
    var intermedSteps = stopAt2ndVisit ? new List.generate(steps, (_) => 1) : [steps];
    for (var step in intermedSteps) {
      switch (direction) {
        case 0:
          pos = new Point(pos.x, pos.y + step);
          break;
        case 1:
          pos = new Point(pos.x + step, pos.y);
          break;
        case 2:
          pos = new Point(pos.x, pos.y - step);
          break;
        case 3:
          pos = new Point(pos.x - step, pos.y);
          break;
      }
      if (stopAt2ndVisit) {
        if (visitedPoints.contains(pos)) {
          return _distance(pos);
        } else {
          visitedPoints.add(pos);
        }
      }
    }
  };
  return _distance(pos);
}
