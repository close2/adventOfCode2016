import 'package:logging/logging.dart';

final _logger = new Logger('cpu');

typedef bool ProbeFunction(Map<String, int> state, List<List<String>> instructions, int pc);
bool _doNothing(Map<String, int> state, List<List<String>> instructions, int pc) {
  return true;
}

typedef void OutFunction(int what);
void _noOut(int what) {
  // Do nothing here.
}

Map<String, int> run(String instructionsString,
    {Map<String, int> initValues: const {}, int version: 1, ProbeFunction probe: _doNothing, OutFunction out: _noOut}) {
  final state = <String, int>{'a': 0, 'b': 0, 'c': 0, 'd': 0};
  initValues.forEach((r, v) => state[r] = v);
  final instructions = instructionsString
      .split('\n')
      .where((instr) => instr.isNotEmpty)
      .map((s) => s.split(' '))
      .toList(growable: false);

  final version2repl = <String, String>{'inc': 'dec', 'dec': 'inc', 'cpy': 'jnz', 'jnz': 'cpy', 'tgl': 'inc'};

  for (int pc = 0; pc < instructions.length; pc++) {
    var probeContinue = probe(state, instructions, pc);
    if (!probeContinue) {
      // The probe function wants us to stop.
      return null;
    }
    var instr = instructions[pc];
    /*_logger.finer('Instructions: \n${instructions.join('\n')}');
    _logger.finer('Registers: \n$state');
    _logger.finer('Current: $pc $instr');
    */
    var p = instr;
    var x = p[1];
    switch (p.first) {
      case 'cpy':
        var y = p.last;
        if (state.containsKey(y)) {
          state[y] = int.parse(x, onError: (reg) => state[reg]);
        }
        break;
      case 'inc':
        if (state.containsKey(x)) {
          state[x]++;
        }
        break;
      case 'dec':
        if (state.containsKey(x)) {
          state[x]--;
        }
        break;
      case 'jnz':
        var y = p.last;
        var xVal = int.parse(x, onError: (reg) => state[reg]);
        var yVal = int.parse(y, onError: (reg) => state[reg]);
        if (xVal != 0) pc += yVal - 1; // -1 because pc will be incremented by for loop.
        break;
      case 'tgl':
        if (version < 2) {
          print('Use of tgl in version1.  Ignoring.');
        } else {
          var y = p.last;
          if (state.containsKey(y)) {
            var yOffset = state[y];
            var instrToModifyIndex = pc + yOffset;
            if (instrToModifyIndex >= 0 && instrToModifyIndex < instructions.length) {
              var instrToModify = instructions[instrToModifyIndex];
              instrToModify[0] = version2repl[instrToModify[0]];
            }
            break;
          }
        }
        break;
      case 'out':
        if (version < 3) {
          print('Use of out in version < 3.  Ignoring.');
        } else {
          out(int.parse(x, onError: (reg) => state[reg]));
        }
        break;
      default:
        print('Unknown instruction: $instr (PC: $pc)');
    }
  }
  return state;
}

int findStartReg(String instructionsString) {
  bool found = false;
  int a = 0; // Will be incremented in while loop => we start with 1
  while(!found) {
    a++;
    var stateWAlternations = <String, int>{};
    int alternations = 0;
    int prevOut = 1;

    bool outputIsAlternating = true;

    bool probe(Map<String, int> state, List<List<String>> instructions, int pc) {
      if (!outputIsAlternating) {
        // Inform simulator to stop.  Output is not alternating.
        return false;
      }

      // Convert state and instructions and pc to a string.
      // If the same state already exists and alternations has at least incremented by 2, we know that we are in a
      // loop with a valid output.
      var stateRep = '$state|$instructions|$pc';

      var prevAlternations = stateWAlternations[stateRep];
      if (prevAlternations == null) {
        stateWAlternations[stateRep] = alternations;
      } else {
        if (prevAlternations + 2 <= alternations) {
          found = true;
          // Inform simulator to stop.
          return false;
        } else {
          // Inform simulator to stop.
          // We are in a loop, with too little (maybe no) output.
          return false;
        }
      }
      // Inform simulator to continue;
      return true;
    };

    void out(int n) {
      if (n != 0 && n != 1) {
        // We have an invalid output:
        outputIsAlternating = false;
      }
      if (prevOut == 0 && n == 1 || prevOut == 1 && n == 0 ) {
        prevOut = n;
        alternations++;
      } else {
        outputIsAlternating = false;
      }
    }

    run(instructionsString, initValues: {'a': a}, version: 3, probe: probe, out: out);
  }
  return a;
}
