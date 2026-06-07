import 'package:flutter/material.dart';

class BookmarkDetailPage extends StatelessWidget {
  final int bookmarkId;

  const BookmarkDetailPage({super.key, required this.bookmarkId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(child: Text('Bookmart #$bookmarkId')),
    );
  }
}
