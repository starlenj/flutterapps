import 'package:flutter/material.dart';
import 'package:todoapp/Features/Bookmark/Model/bookmark_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookmarkDetailPage extends StatelessWidget {
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
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: bookmark.tumbnailUrl != null
                      ? Image.network(bookmark.tumbnailUrl!, fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.video_library, size: 50),
                        ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.play_circle_fill,
                    size: 70,
                    color: Colors.white,
                  ),
                  onPressed: () => _launchVideo(bookmark.url),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookmark.title ?? 'No Title',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const Divider(height: 32),
                  if (bookmark.timestampSeconds != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.timer, color: Colors.blue),
                      title: Text('Reamining : ${bookmark.timestampSeconds}'),
                    ),
                  const Text(
                    'Notes :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bookmark.note ?? 'Notes are empty',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            label: const Text('Continue Video'),
            icon: const Icon(Icons.open_in_browser),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () => _launchVideo(bookmark.url),
          ),
        ),
      ),
    );
  }

  void _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrlString(url)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
