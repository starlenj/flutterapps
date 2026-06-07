class TimestampParser {
  int? parse(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    final t = uri.queryParameters['t'];

    if (t != null) return _parseTimeValue(t);

    final start = uri.queryParameters['start'];
    if (start != null) return int.tryParse(start);

    if (uri.fragment.contains("t=")) {
      final vimeoT = uri.fragment.replaceFirst('t=', '');
      return _parseTimeValue(vimeoT);
    }
    return null;
  }

  int? _parseTimeValue(String value) {
    final pureInt = int.tryParse(value);
    if (pureInt != null) return pureInt;

    // h, m, s içeren regex analizi
    int totalSeconds = 0;
    final hourMatch = RegExp(r'(\d+)h').firstMatch(value);
    final minMatch = RegExp(r'(\d+)m').firstMatch(value);
    final secMatch = RegExp(r'(\d+)s').firstMatch(value);

    if (hourMatch != null)
      totalSeconds += int.parse(hourMatch.group(1)!) * 3600;
    if (minMatch != null) totalSeconds += int.parse(minMatch.group(1)!) * 60;
    if (secMatch != null) totalSeconds += int.parse(secMatch.group(1)!);

    return totalSeconds > 0 ? totalSeconds : null;
  }
}
