import 'package:adventofcode2016/signal.dart';
import 'package:test/test.dart';

const testInput = """
eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
""";

void allTests() {
  test('ex1', () {
    expect(extractMessage(testInput), 'easter');
  });
  test('B ex1', () {
    expect(extractMessage(testInput, useLeastCommon: true), 'advent');
  });
}
