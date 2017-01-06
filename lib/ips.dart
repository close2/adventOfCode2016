import 'dart:math' as math;
import 'package:logging/logging.dart';

final _logger = new Logger('ips');

int countIpsSupportingTls(String allIpsString) {
  return allIpsString.trim().split('\n').where(supportsTls).length;
}

int countIpsSupportingSsl(String allIpsString) {
  return allIpsString.trim().split('\n').where(supportsSsl).length;
}

bool supportsTls(String ip) {
  bool insideBrackets = false;
  bool abbaFound = false;
  for (int i = 0; i < ip.length - 3; i++) {
    if (ip[i] == '[') {
      insideBrackets = true;
      continue;
    } else if (ip[i] == ']') {
      insideBrackets = false;
      continue;
    }
    if (abbaFound && !insideBrackets) {
      continue;
    }
    if (ip[i] == ip[i + 3] && ip[i] != ip[i + 1] && ip[i + 1] == ip[i + 2]) {
      if (insideBrackets) {
        return false;
      } else {
        abbaFound = true;
      }
    }
  }
  return abbaFound;
}

Set<String> _extractAllBabs(String ip) {
  var insideBrackets = false;
  final babs = new Set<String>();
  for (int i = 0; i < ip.length - 2; i++) {
    if (ip[i] == '[') {
      insideBrackets = true;
      continue;
    } else if (ip[i] == ']') {
      insideBrackets = false;
      continue;
    }
    if (!insideBrackets) continue;
    if (ip[i] == ip[i + 2] && ip[i] != ip[i + 1]) {
      babs.add('${ip[i]}${ip[i + 1]}${ip[i + 2]}');
    }
  }
  _logger.finer('Babs for $ip: $babs');
  return babs;
}

bool supportsSsl(String ip) {
  final allBabs = _extractAllBabs(ip);
  bool insideBrackets = false;
  for (int i = 0; i < ip.length - 2; i++) {
    var l1 = ip[i];
    if (l1 == '[') {
      insideBrackets = true;
      continue;
    } else if (l1 == ']') {
      insideBrackets = false;
      continue;
    }
    if (insideBrackets) continue;
    var l2 = ip[i + 1];
    var l3 = ip[i + 2];
    if (l1 == l3 && l1 != l2) {
      _logger.finer('$ip; Current Aba: $l1$l2$l3');
      var corBab = '$l2$l1$l2';
      if (allBabs.contains(corBab)) return true;
    }
  }
  return false;
}

class _Range implements Comparable<_Range> {
  final int from;
  final int to;

  _Range(this.from, this.to);

  factory _Range.fromString(String s) {
    var rd = s.split('-');
    return new _Range(int.parse(rd[0]), int.parse(rd[1]));
  }

  @override
  int compareTo(_Range other) {
    if (other.from != from) return from.compareTo(other.from);
    return to.compareTo(other.to);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is _Range && this.from == other.from && this.to == other.to;
  }

  @override
  int get hashCode {
    return from.hashCode ^ to.hashCode;
  }
}

int findAllowedIp(String blockedIpsString, {bool countRange: false}) {
  var ranges = blockedIpsString
      .split('\n')
      .where((s) => s.isNotEmpty)
      .map((s) => new _Range.fromString(s))
      .toList(growable: false);
  ranges.sort();
  if (ranges.first.from > 0) return 0;

  var count = 0;
  var to = ranges.first.to;
  for (int i = 0; i < ranges.length; i++) {
    var currentRange = ranges[i];
    if (currentRange.from > to + 1) {
      if (!countRange) {
        return to + 1;
      }
      count += currentRange.from - (to + 1);
    }

    to = math.max(to, currentRange.to);
  }

  if (!countRange) print('Could not find a solution');
  return count;
}
