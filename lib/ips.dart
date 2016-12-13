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
