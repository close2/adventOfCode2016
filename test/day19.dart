import 'package:adventofcode2016/elephants.dart';
import 'package:test/test.dart';

void allTests() {
  test('ex1', () {
    expect(findWinner(5), 3);
  });
  test('ex2', () {
    expect(findWinnerRound(5), 2);
  });
}
