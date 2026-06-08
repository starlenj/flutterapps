import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/Features/Bookmark/Model/bookmark_model.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class BookmarkCard extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  const BookmarkCard({
    super.key,
    required this.bookmark,
    this.onTap,
    this.onDelete,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final title = bookmark.title ?? bookmark.domain ?? 'Unkown';
    final subTitle = bookmark.domain ?? bookmark.url;

    return Card(
      margin: const EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        onLongPress: onShare,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _buildThumnail(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        if (bookmark.timestampSeconds != null)
                          Container(
                            padding: const EdgeInsetsGeometry.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${bookmark.timestampSeconds}s',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showActionSheet(context),
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumnail() {
    final url = bookmark.tumbnailUrl;
    if (url == null) {
      return Container(
        width: 88,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.link, color: Colors.grey),
      );
    }
    final uri = Uri.tryParse(url);
    final valid =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    if (!valid) {
      return Container(
        width: 88,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 88,
        height: 56,
        fit: BoxFit.cover,
        placeholder: (c, u) => Container(color: Colors.grey[200]),
        errorWidget: (c, u, e) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('Open'),
              onTap: () {
                Navigator.pop(context);
                onTap?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. OPEN SEÇENEĞİ: Harici uygulama/tarayıcı açar
              ListTile(
                leading: const Icon(Icons.open_in_browser, color: Colors.blue),
                title: const Text('Open (Tarayıcıda Aç)'),
                onTap: () async {
                  Navigator.pop(context); // Menüyü kapat
                  final uri = Uri.parse(bookmark.url);
                  if (await canLaunchUrl(uri)) {
                    // mode: LaunchMode.externalApplication -> Bu kısım kritik!
                    // YouTube ise YouTube uygulamasını, değilse Safari/Chrome'u açar.
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),

              // 2. SHARE SEÇENEĞİ: WhatsApp, mesajlar vb. paylaşım menüsü
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('Share (Paylaş)'),
                onTap: () {
                  final box = context.findRenderObject() as RenderBox?;
                  Navigator.pop(context); // Menüyü kapat
                  // Paylaşım menüsünü açar
                  Share.share(
                    '${bookmark.title}\n${bookmark.url}',
                    sharePositionOrigin: box != null
                        ? box.localToGlobal(Offset.zero) & box.size
                        : null,
                  );
                },
              ),

              // 3. DETAILS SEÇENEĞİ (İsteğe bağlı): Uygulama içi detay sayfası
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('View Details (Uygulama İçi)'),
                onTap: () {
                  Navigator.pop(context);
                  // Burası senin şu an çalışan "Details" ekranına giden kod olmalı
                  context.push('/details/${bookmark.id}');
                },
              ),

              const Divider(),

              // SİL SEÇENEĞİ
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
