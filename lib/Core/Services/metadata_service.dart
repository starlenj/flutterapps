import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

class MetadataService {
  Future<UrlMetadata> fetch(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: {'User-Agent': 'Mozilla/5.0'})
          .timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        return UrlMetadata(domain: Uri.tryParse(url)?.host);
      }
      final html = response.body;
      final unescape = HtmlUnescape();
      return UrlMetadata(
        title:
            _extractMeta(html, 'og:title') ??
            _extractMeta(html, 'twitter:title') ??
            _extractTitle(html),
        image: _extractMeta(html, 'og:image'),
        desctiption: _extractMeta(html, 'og:desctiption'),
        domain: Uri.parse(url).host,
      );
    } catch (_) {
      return UrlMetadata(domain: Uri.tryParse(url)?.host);
    }
  }

  String? _extractMeta(String html, String propert) {
    // Başına r koyarak $ işaretinin özel karakter algılanmasını engelliyoruz
    final regex = RegExp(
      r'<meta[^>]+(?:property|name)="([^"]+)"[^>]+content="([^"]+)"',
    );
    return regex.firstMatch(html)?.group(1);
  }

  String? _extractTitle(String html) {
    final reg = RegExp('<title>([^<]+)</title>', caseSensitive: false);
    final match = reg.firstMatch(html);
    return match?.group(1)?.trim();
  }
}

class UrlMetadata {
  final String? title;
  final String? image;
  final String? desctiption;
  final String? domain;
  UrlMetadata({this.title, this.image, this.desctiption, this.domain});
}
