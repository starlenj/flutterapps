import 'package:flutter/material.dart';
import 'package:todoapp/Features/Bookmark/Model/bookmark_model.dart';

class BookmarkDetailPage extends StatelessWidget {
  final int bookmarkId;
  final Bookmark bookmark;

  const BookmarkDetailPage({super.key, required this.bookmark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(aspectRatio: 16 / 9, child: bookmark.image),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
