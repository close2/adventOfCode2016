String generateData(String seed, int length) {
  final sb = new StringBuffer();
  sb.write(seed);
  while(sb.length < length) {
    var current = sb.toString();
    sb.write('0');
    for (int i = current.length - 1; i >= 0 && sb.length < length; i--) {
      sb.write(current[i] == '0' ? '1' : '0');
    }
  }
  return sb.toString();
}

String calcChecksum(String data) {
  String checksum = data;
  do {
    final sb = new StringBuffer();
    for (int i = 0; i < checksum.length; i += 2) {
      sb.write(checksum[i] == checksum[i + 1] ? '1' : '0');
    }
    checksum = sb.toString();
  } while(checksum.length.isEven);
  return checksum.toString();
}
