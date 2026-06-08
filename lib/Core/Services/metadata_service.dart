import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:html_unescape/html_unescape.dart';

class UrlMetadata {
  final String? title;
  final String? image;
  final String? description;
  final String? domain;

  UrlMetadata({this.title, this.image, this.description, this.domain});

  @override
  String toString() =>
      'UrlMetadata(title: $title, image: $image, description: $description, domain: $domain)';
}

class MetadataService {
  final _unescaper = HtmlUnescape();

  Future<UrlMetadata> fetch(String url) async {
    try {
      final uri = Uri.parse(url);
      final resp = await http
          .get(
            uri,
            headers: {
              'User-Agent': 'Mozilla/5.0 (compatible; BookmarkFetcher/1.0)',
              'Accept': 'text/html',
            },
          )
          .timeout(const Duration(seconds: 8));

      if (resp.statusCode != 200) {
        return UrlMetadata(domain: uri.host);
      }

      final doc = html_parser.parse(resp.body);

      // 1) Open Graph
      final ogTitle = _metaContent(doc, 'property', 'og:title');
      final ogImage = _metaContent(doc, 'property', 'og:image');
      final ogDesc = _metaContent(doc, 'property', 'og:description');

      // 2) Twitter
      final twTitle = _metaContent(doc, 'name', 'twitter:title');
      final twDesc = _metaContent(doc, 'name', 'twitter:description');

      // 3) standard meta description
      final desc = _metaContent(doc, 'name', 'description') ?? ogDesc ?? twDesc;

      // 4) title tag
      final titleTag = _titleTag(doc);

      // Determine title priority
      String? title = ogTitle ?? twTitle ?? titleTag ?? desc;
      if (title != null) title = _unescaper.convert(title).trim();
      if (title != null && title.isEmpty) title = null;

      String? image = ogImage;
      if (image != null && image.trim().isEmpty) image = null;

      final domain = uri.host;

      return UrlMetadata(
        title: title,
        image: image,
        description: desc,
        domain: domain,
      );
    } catch (e) {
      final host = Uri.tryParse(url)?.host;
      return UrlMetadata(domain: host);
    }
  }

  // helper: gets meta content by attribute name/value, skipping apple-itunes-app tags
  String? _metaContent(dom.Document doc, String attrName, String attrValue) {
    try {
      final node = doc.head?.querySelector('meta[$attrName="$attrValue"]');
      if (node == null) return null;
      final content = node.attributes['content']?.trim();
      if (content == null || content.isEmpty) return null;

      // skip apple smart-banner entries
      final nameLower = (attrValue).toLowerCase();
      if (nameLower == 'apple-itunes-app' || nameLower.startsWith('apple-'))
        return null;

      return content;
    } catch (_) {
      return null;
    }
  }

  String? _titleTag(dom.Document doc) {
    final titleElem = doc.head?.querySelector('title');
    final t = titleElem?.text;
    if (t == null || t.trim().isEmpty) return null;
    return t.trim();
  }
}
