import 'dart:collection';

import 'package:trotter/trotter.dart';
import 'package:built_collection/built_collection.dart';
import 'package:logging/logging.dart';
import 'package:collection/collection.dart' show PriorityQueue;

final _logger = new Logger('microchips');

enum Type { Generator, Microcontroller }

class Component {
  String name;
  Type type;

  Component(this.name, this.type);

  String toString() {
    return (type == Type.Generator ? 'G' : 'M') + name;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Component && this.name == other.name && this.type == other.type;
  }

  @override
  int get hashCode {
    return name.hashCode ^ type.hashCode;
  }
}

State _parseInitState(String s, String addItemsString) {
  var res = <BuiltSet<Component>>[];

  final elsRegExp = new RegExp(r' ([a-zA-Z]+).(generator|compatible)');
  Set<Component> descToComponents(String desc) {
    var matches = elsRegExp.allMatches(desc);
    if (matches.isEmpty) {
      return new Set();
    } else {
      var current = new Set<Component>();
      matches.forEach((match) {
        var name = match[1];
        var type = match[2] == 'generator' ? Type.Generator : Type.Microcontroller;
        current.add(new Component(name, type));
      });
      return current;
    }
  }

  s.split('\n').where((s) => s.isNotEmpty).forEach((levelDesc) {
    res.add(new BuiltSet<Component>(descToComponents(levelDesc)));
  });
  var addItemDescs = addItemsString.split('\n').where((s) => s.isNotEmpty);
  if (addItemDescs.isNotEmpty) {
    var addItems = addItemDescs.map(descToComponents).reduce((set1, set2) => set1.union(set2));
    var level0Builder = res[0].toBuilder();
    level0Builder.addAll(addItems);
    res[0] = level0Builder.build();
  }
  return new State(0, new BuiltList<BuiltSet>(res));
}

class State {
  int elevator;
  final BuiltList<BuiltSet<Component>> levels;
  State(this.elevator, this.levels);

  String toString() {
    final sb = new StringBuffer();
    for (int i = levels.length - 1; i >= 0; i--) {
      sb..write(i == elevator ? 'E' : ' ')..write(' ');
      sb.writeln(levels[i].toList(growable: false).join(' '));
    }
    return sb.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is State && this.elevator == other.elevator && this.levels == other.levels;
  }

  @override
  int get hashCode {
    return elevator.hashCode ^ levels.hashCode;
  }
}

class Node {
  State state;

  // G cost: distance from initState
  // H cost: distance to endState
  // F cost: G + H
  final int g;
  final int h;
  final int f;
  final Node parent;

  Node(this.state, this.parent, this.g, this.h) : f = g + h;
}

int _calcDistanceToEnd(State state) {
  int i = state.levels.length - 1;
  return state.elevator + state.levels.fold(0, (prev, level) => prev + level.length * i--);
}

bool _validateLevel(BuiltSet<Component> level) {
  var generators = level.where((c) => c.type == Type.Generator);
  bool isValid = true;
  if (generators.isNotEmpty) {
    bool anyMicWithoutGen = level
        .where((comp) => comp.type == Type.Microcontroller)
        .any((comp) => !generators.contains(new Component(comp.name, Type.Generator)));
    isValid = !anyMicWithoutGen;
  }
  //_logger.finer('Validating level $level => $isValid');
  return isValid;
}

BuiltList<BuiltSet<Component>> moveItemsAndValidate(State currentState, var itemsToMove, toLevel) {
  var fromLevel = currentState.elevator;

  var oldLevels = currentState.levels;
  var oldFromLevelComponents = oldLevels[fromLevel];
  var oldToLevelComponents = oldLevels[toLevel];
  var fromLevelComponents = (oldFromLevelComponents.toBuilder()..removeAll(itemsToMove)).build();
  var toLevelComponents = (oldToLevelComponents.toBuilder()..addAll(itemsToMove)).build();
  if (_validateLevel(fromLevelComponents) && _validateLevel(toLevelComponents)) {
    var newLevelsBuilder = currentState.levels.toBuilder();
    newLevelsBuilder[fromLevel] = new BuiltSet<Component>(fromLevelComponents);
    newLevelsBuilder[toLevel] = new BuiltSet<Component>(toLevelComponents);
    return newLevelsBuilder.build();
  }
  return null;
}

List<State> buildNeighbours(State state) {
  var currentLevel = state.elevator;
  var componentsOnCurrentLevel = state.levels[currentLevel];
  var subsets = new Subsets(componentsOnCurrentLevel.toList(growable: false))
      .range() // TODO convert Subsets to provide an iterable.
      .where((List s) => s.isNotEmpty && s.length <= 2);
  //_logger.finer('Subsets: $subsets');
  var newStates = <State>[];
  var levelsBelowEmpty = state.levels.take(currentLevel).every((level) => level.isEmpty);
  for (int dir in [-1, 1]) {
    if (currentLevel == 0 && dir == -1) continue;
    if (currentLevel == state.levels.length - 1 && dir == 1) continue;
    // let's find all valid states when going one level down.
    newStates.addAll(subsets
        .map((itemsToMove) => moveItemsAndValidate(state, itemsToMove, currentLevel + dir))
        .where((levels) => levels != null)
        // Don't move one element down if all other levels below are empty
        .where((levels) => dir > 0 || !levelsBelowEmpty || levels.length > 1)
        .map((levels) => new State(currentLevel + dir, levels)));
  }
  return newStates;
}

State buildEndState(State initState) {
  var levelCount = initState.levels.length;
  var endLevels = new List<Iterable<Component>>.filled(levelCount, []);
  endLevels[levelCount - 1] = initState.levels.asList().expand((_) => _);
  var buildEndLevels = endLevels.map((l) => new BuiltSet<Component>(l));
  return new State(levelCount - 1, new BuiltList<BuiltSet<Component>>(buildEndLevels));
}

Node _buildNode(Node parent, State state) {
  var h = _calcDistanceToEnd(state);
  var g = parent.g + 1;
  return new Node(state, parent, g, h);
}

List<State> calcSteps(String initStateString, {String addItemsString = ''}) {
  final initState = _parseInitState(initStateString, addItemsString);
  final endState = buildEndState(initState);

  final openNodes = new HashMap<State, Node>();
  final openNodesList = new PriorityQueue<Node>((n1, n2) {
    var fComp = n1.f - n2.f;
    if (fComp != 0) return fComp;
    return n1.hashCode - n2.hashCode;
  });
  final closedNodes = new Set<State>();

  var initNode = new Node(initState, null, 0, _calcDistanceToEnd(initState));
  openNodesList.add(initNode);
  openNodes[initState] = initNode;

  for (;;) {
    Node currentNode = openNodesList.removeFirst();
    State currentState = currentNode.state;
    openNodes.remove(currentState);

    //_logger.finer('Current state: $currentState (g: ${currentNode.g}, h: ${currentNode.h}');
    closedNodes.add(currentState);

    if (currentState == endState) {
      _logger.finer('Found endState');
      var steps = <State>[];
      var runner = currentNode;
      while (runner.parent != null) {
        steps.insert(0, runner.state);
        runner = runner.parent;
      }
      _logger.finer('Steps required: $steps');
      return steps;
    }

    var neighbours = buildNeighbours(currentState);
    neighbours.forEach((neighbourState) {
      if (closedNodes.contains(neighbourState)) return;

      Node n = openNodes[neighbourState];
      if (n != null) {
        var newNode = _buildNode(currentNode, neighbourState);
        if (newNode.g < n.g) {
          _logger.finer('Shorter way to state: $neighbourState via $currentState (${n.g} => ${newNode.g})');
          openNodes[neighbourState] = newNode;
          openNodesList
            ..remove(n)
            ..add(newNode);
        }
      } else {
        //_logger.finer('New state: $neighbourState');
        var newNode = _buildNode(currentNode, neighbourState);
        openNodes[neighbourState] = newNode;
        openNodesList.add(newNode);
      }
    });
  }
}
