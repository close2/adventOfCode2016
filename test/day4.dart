import 'package:adventofcode2016/rooms.dart';
import 'package:test/test.dart';

void allTests() {
  test('day4 ex1', () {
    expect(verifyChecksum('aaaaa-bbb-z-y-x-123[abxyz]'), true);
  });
  test('day4 ex2', () {
    expect(verifyChecksum('a-b-c-d-e-f-g-h-987[abcde]'), true);
  });
  test('day4 ex3', () {
    expect(verifyChecksum('not-a-real-room-404[oarel]'), true);
  });
  test('day4 ex4', () {
    expect(verifyChecksum('totally-real-room-200[decoy]'), false);
  });
  test('day4 decryption', () {
    expect(new Room('qzmt-zixmtkozy-ivhz-343[]').decryptedName, 'very encrypted name');
  });
}
