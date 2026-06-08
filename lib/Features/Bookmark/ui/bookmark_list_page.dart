import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Features/Bookmark/Model/bookmark_model.dart';
import 'package:todoapp/Features/Bookmark/Providers/bookmart_state.dart';
import 'package:todoapp/Features/Bookmark/ui/bookmark_card.dart';
import '../providers/bookmark_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class BookmarkListPage extends ConsumerStatefulWidget {
  const BookmarkListPage({super.key});

  @override
  ConsumerState<BookmarkListPage> createState() => _BookmarkListPageState();
}

class _BookmarkListPageState extends ConsumerState<BookmarkListPage> {
  final _searchCtrl = TextEditingController();
  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookmarkProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => ref.read(bookmarkProvider.notifier).search(v),
              decoration: InputDecoration(
                hintText: 'Ara (başlık,domain,url)...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchCtrl.clear();
                    ref.read(bookmarkProvider.notifier).search('');
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(bookmarkProvider.notifier).load();
        },
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(BookmartState state) {
    if (state.isLoading)
      return const Center(child: CircularProgressIndicator());

    final items = (state.searchQuery == null || state.searchQuery!.isEmpty)
        ? state.items
        : state.filtered;
    if (items.isEmpty) {
      return const Center(child: Text('Not Found'));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final Bookmark b = items[i];
        return Dismissible(
          key: ValueKey(b.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete_forever, color: Colors.white),
          ),
          onDismissed: (_) async {
            await ref.read(bookmarkProvider.notifier).delete(b.id);
            if (!mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('deleted')));
            }
          },
          child: BookmarkCard(
            bookmark: b,
            onTap: () => context.push('/detail/${b.id}'),
            onDelete: () async {
              await ref.read(bookmarkProvider.notifier).delete(b.id);
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Deleted')));
            },
            onShare: () => _shareOrCopy(context, b.url),
          ),
        );
      },
    );
  }

  Future<void> _shareOrCopy(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Valid Url')));
      return;
    }
    debugPrint('safeShare called for: $url; platform isWeb=$kIsWeb');
    try {
      await Share.share(url);
      await Clipboard.setData(ClipboardData(text: url));
      final snackbar = SnackBar(
        content: const Text('Url Panoya kopyalandı'),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () => launchUrl(uri, mode: LaunchMode.externalApplication),
        ),
      );
    } catch (e) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
