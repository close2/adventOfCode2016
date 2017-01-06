import 'package:adventofcode2016/ips.dart';
import 'package:test/test.dart';

const ex1 = '''
5-8
0-2
4-7
''';

void allTests() {
  test('ex1', () {
    expect(findAllowedIp(ex1), 3);
  });
}
