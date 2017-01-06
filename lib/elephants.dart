import 'package:logging/logging.dart';

final _logger = new Logger('elephants');

int findWinner(int nbElves) {
  var elves = new List<int>.generate(nbElves, (i) => (i + 1) % nbElves);
  int elvesInPlay = nbElves;
  int currentElve = 0;
  while(elvesInPlay > 1) {
    var removeElf = elves[currentElve];
    var nextElfBecomes = elves[removeElf];
    elves[currentElve] = nextElfBecomes;
    elvesInPlay--;
    currentElve = elves[currentElve];
  }
  // Attention: elves start counting with 1!
  return currentElve + 1;
}

int findWinnerRound(int nbElves) {
  var elves = new List<int>.generate(nbElves, (i) => (i + 1) % nbElves);
  int elvesInPlay = nbElves;

  int currentElf = 0;
  int currentElfNb = currentElf;

  int otherElf = nbElves ~/ 2;
  int otherPrevElf = otherElf - 1;
  int otherElfNb = otherElf;

  while(elvesInPlay > 1) {
    var removeElfNb = (currentElfNb + (elvesInPlay ~/ 2)) % elvesInPlay;


    while(removeElfNb != otherElfNb) {
      otherPrevElf = otherElf;
      otherElf = elves[otherElf];
      otherElfNb = (otherElfNb + 1) % elvesInPlay;
    }
    var removeElf = otherElf;

    otherElfNb--;
    otherElf = otherPrevElf;
    elves[otherElf] = elves[removeElf];
    if (otherElfNb < currentElfNb) {
      currentElfNb = (currentElfNb - 1) % elvesInPlay;
    }

    elvesInPlay--;
    currentElf = elves[currentElf];
    currentElfNb = (currentElfNb + 1) % elvesInPlay;
  }
  // Attention: elves start counting with 1!
  return currentElf + 1;

}
