// lib/features/bookmark/ui/bookmark_add_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bookmark_provider.dart';
import 'package:go_router/go_router.dart';

class BookmarkAddPage extends ConsumerStatefulWidget {
  final String? initialUrl;
  const BookmarkAddPage({super.key, this.initialUrl});

  @override
  ConsumerState<BookmarkAddPage> createState() => _BookmarkAddPageState();
}

class _BookmarkAddPageState extends ConsumerState<BookmarkAddPage> {
  final _urlCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null) _urlCtrl.text = widget.initialUrl!;
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    _noteCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final url = _urlCtrl.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('URL boş olamaz')));
      return;
    }

    final tags = _tagsCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    setState(() => _saving = true);
    try {
      await ref
          .read(bookmarkProvider.notifier)
          .addUrl(url, note: _noteCtrl.text.trim(), tagNames: tags);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kaydedildi')));
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(bookmarkProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bookmark')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlCtrl,
              decoration: const InputDecoration(labelText: 'URL'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteCtrl,
              decoration: const InputDecoration(labelText: 'Note (opsiyonel)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tagsCtrl,
              decoration: const InputDecoration(
                labelText: 'Tags (virgülle ayır)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: (_saving || isLoading) ? null : _save,
              icon: const Icon(Icons.save),
              label: Text(
                (_saving || isLoading) ? 'Kaydediliyor...' : 'Kaydet',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
