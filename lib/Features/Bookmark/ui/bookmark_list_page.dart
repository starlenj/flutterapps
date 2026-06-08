// lib/features/bookmark/ui/bookmark_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Features/Bookmark/Providers/bookmart_state.dart';
import '../providers/bookmark_provider.dart';
import 'package:go_router/go_router.dart';

class BookmarkListPage extends ConsumerWidget {
  const BookmarkListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookmarkProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(bookmarkProvider.notifier).load(),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.pushNamed('add'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              onChanged: (v) => ref.read(bookmarkProvider.notifier).search(v),
              decoration: InputDecoration(
                hintText: 'Ara (başlık, domain, url)...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(state, ref),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BookmartState state, WidgetRef ref) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = state.searchQuery == null || state.searchQuery!.isEmpty
        ? state.items
        : state.filtered;

    if (items.isEmpty) {
      return const Center(child: Text('Henüz kaydedilmiş öğe yok'));
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final b = items[index];
        return Dismissible(
          key: ValueKey(b.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => ref.read(bookmarkProvider.notifier).delete(b.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete_forever, color: Colors.white),
          ),
          child: ListTile(
            leading: b.tumbnailUrl != null
                ? Image.network(
                    b.tumbnailUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.link),
            title: Text(b.title ?? b.domain ?? 'İsimsiz'),
            subtitle: Text(
              b.domain ?? b.url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: b.timestampSeconds != null
                ? Chip(label: Text('${b.timestampSeconds}s'))
                : null,
            onTap: () {
              context.push('/detail/${b.id}');
            },
          ),
        );
      },
    );
  }

  Widget _buildThumbnail(String? thumbnailUrl) {
    if (thumbnailUrl == null) {
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

    final uri = Uri.tryParse(thumbnailUrl);
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

    // cached_network_image veya Image.network kullan
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: thumbnailUrl,
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
}
