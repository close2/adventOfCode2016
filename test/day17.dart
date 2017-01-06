import 'package:adventofcode2016/passcode.dart';
import 'package:test/test.dart';

void allTests() {
  test('ex1', () {
    expect(getPath('ihgpwlah'), 'DDRRRD');
  });
  test('ex2', () {
    expect(getPath('kglvqrro'), 'DDUDRLRRUDRD');
  });
  test('ex3', () {
    expect(getPath('ulqzkmiv'), 'DRURDRUDDLLDLUURRDULRLDUUDDDRR');
  });
  test('ex4', () {
    expect(getPath('ihgpwlah', longest: true).length, 370);
  });
  test('ex5', () {
    expect(getPath('kglvqrro', longest: true).length, 492);
  });
  test('ex6', () {
    expect(getPath('ulqzkmiv', longest: true).length, 830);
  });
}
