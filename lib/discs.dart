class _Disc {
  final int discNb;
  final int positions;
  final int startPosition;

  // Disc #1 has 5 positions; at time=0, it is at position 4.
  static final _discReg = new RegExp(r'Disc #([0-9]+) has ([0-9]+) positions; at time=([0-9+]), .*position ([0-9]+)\.');

  _Disc(this.discNb, this.positions, this.startPosition);

  factory _Disc.fromDescr(String s) {
    var match = _discReg.firstMatch(s);
    var discNb = int.parse(match[1]);
    var positions = int.parse(match[2]);
    var time = int.parse(match[3]);
    var initPos = int.parse(match[4]);
    return new _Disc(discNb, positions, (initPos - time + positions) % positions);
  }
}

int calcPosition(String discDescriptions, {int addDisk: null}) {
  final discs = discDescriptions
      .split('\n')
      .where((s) => s.isNotEmpty)
      .map((s) => new _Disc.fromDescr(s))
      .toList();
  if (addDisk != null) {
    discs.add(new _Disc(discs.length + 1, 11, 0));
  }
  for (int i = 0;; i++) {
    if (discs.every((disc) => (disc.startPosition + i + disc.discNb) % disc.positions == 0)) return i;
  }
}
