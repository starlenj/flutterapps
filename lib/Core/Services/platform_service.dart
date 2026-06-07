import 'package:todoapp/Features/Bookmark/Model/bookmark_model.dart';

class PlatformService {
  Platform detect(String url) {
    final u = url.toLowerCase();
    if (u.contains('youtube.com') || u.contains('youtu.be'))
      return Platform.youtube;
    if (u.contains('instagram.com')) return Platform.instagram;
    if (u.contains('x.com') || u.contains('twitter.com')) return Platform.x;
    if (u.contains('tiktok.com')) return Platform.tiktok;
    if (u.contains('vimeo.com')) return Platform.vimeo;
    return Platform.web;
  }
}
