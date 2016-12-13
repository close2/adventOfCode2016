String extractMessage(String allLines, {bool useLeastCommon: false}) {
  var lines = allLines.trim().split('\n');
  final message = new StringBuffer();
  for (int i = 0; i < lines.first.length; i++) {
    var counts = <String, int>{};
    lines.forEach((l) {
      var char = l[i];
      var currentCount = counts[char] ?? 0;
      counts[char] = currentCount + 1;
    });
    var bestMatch = null;
    var bestCount = useLeastCommon ? lines.length + 1 : 0;
    counts.forEach((char, count) {
      if (!useLeastCommon && count > bestCount || useLeastCommon && count < bestCount) {
        bestMatch = char;
        bestCount = count;
      }
    });
    message.write(bestMatch);
  }
  return message.toString();
}
