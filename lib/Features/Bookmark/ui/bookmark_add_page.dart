import 'package:flutter/material.dart';

class BookmarkAddPage extends StatelessWidget {
  final String? initialUrl;

  const BookmarkAddPage({super.key, this.initialUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add')),
      body: Center(child: Text(initialUrl ?? 'Add Bookmark')),
    );
  }
}
