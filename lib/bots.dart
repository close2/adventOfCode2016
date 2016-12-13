import 'dart:math' as math;
import 'package:logging/logging.dart';

final _logger = new Logger('bots');

final state = <String, List<int>>{};

var stopAtInputs = <int>[];
String stoppedAt;

class Bot {
  String name;
  String low;
  String high;
  Bot(this.name, this.low, this.high);

  void compare() {
    var myInputs = state[name];
    if (myInputs.length != 2) {
      print('Did not get 2 inputs $myInputs');
      return;
    }
    int lowInput = myInputs.reduce(math.min);
    int highInput = myInputs.reduce(math.max);
    _logger.info('$name: comparing $lowInput (for $low) to $highInput (for $high)');

    if (stopAtInputs.contains(lowInput) && stopAtInputs.contains(highInput)) {
      stoppedAt = name;
      state.clear();
      return;
    }

    state[low] = (state[low] ?? [])..add(lowInput);
    state[high] = (state[high] ?? [])..add(highInput);

    state.remove(name);
  }
}

void work(String instructionsString) {
  var bots = <String, Bot>{};

  var instructions = instructionsString.split('\n').where((s) => s.isNotEmpty);
  instructions.forEach((instr) {
    var instrSplit = instr.split(' ');
    switch (instrSplit[0]) {
      case 'value':
        var val = int.parse(instrSplit[1]);
        var toBot = instrSplit[5];
        var input = state[toBot] ?? [];
        state[toBot] = input..add(val);
        break;
      case 'bot':
        var bot = instrSplit[1];
        String low = instrSplit[6];
        String high = instrSplit[11];
        if (instrSplit[5] == 'output') {
          low = 'o$low';
        }
        if (instrSplit[10] == 'output') {
          high = 'o$high';
        }
        bots[bot] = new Bot(bot, low, high);
        break;
      default:
        print('Unknown instr. $instr');
        return;
    }
  });

  for (;;) {
    var next = state.keys
        .where((botName) => botName[0] != 'o')
        .firstWhere((botName) => state[botName].length == 2, orElse: () => null);
    if (next != null) {
      bots[next].compare();
    } else {
      break;
    }
  }
  _logger.finer('Finale state: $state');
}
