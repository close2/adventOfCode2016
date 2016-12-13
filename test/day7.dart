import 'package:adventofcode2016/ips.dart';
import 'package:test/test.dart';

void allTests() {
  test('ex1', () {
    expect(supportsTls('abba[mnop]qrst'), true);
  });
  test('ex2', () {
    expect(supportsTls('abcd[bddb]xyyx'), false);
  });
  test('ex3', () {
    expect(supportsTls('aaaa[qwer]tyui'), false);
  });
  test('ex4', () {
    expect(supportsTls('ioxxoj[asdfgh]zxcvbn'), true);
  });
  test('B ex1', () {
    expect(supportsSsl('aba[bab]xyz'), true);
  });
  test('B ex2', () {
    expect(supportsSsl('xyx[xyx]xyx'), false);
  });
  test('B ex3', () {
    expect(supportsSsl('aaa[kek]eke'), true);
  });
  test('B ex4', () {
    expect(supportsSsl('zazbz[bzb]cdb'), true);
  });
}
