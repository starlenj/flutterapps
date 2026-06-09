import 'package:flutter/material.dart';
import 'package:todoapp/Features/Bookmark/Model/bookmark_model.dart';
import 'package:todoapp/Features/Bookmark/ui/bookmark_detail_page.dart';
import '../Repository/bookmark_repository.dart';

class BookMarkDetailLoaderPage extends StatelessWidget {
  final String id;
  const BookMarkDetailLoaderPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Bookmark?>(
      future: BookmarkRepository.instance.loadBookmarkById(id),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Hata ${snap.error}')));
        }
        final bookmark = snap.data;
        if (bookmark == null) {
          return const Scaffold(body: Center(child: Text('Not Found')));
        }
        return BookmarkDetailPage(bookmark: bookmark);
      },
    );
  }
}
