import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Features/Bookmark/Model/bookmark_model.dart';
import 'package:todoapp/Features/Bookmark/Providers/bookmart_state.dart';
import 'package:todoapp/Features/Bookmark/Repository/bookmark_repository.dart';
import 'package:todoapp/Features/Tags/Providers/tag_provider.dart';

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepository();
});

final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, BookmartState>(
  (ref) {
    return BookmarkNotifier(
      ref.watch(bookmarkRepositoryProvider),
      ref, // Tag notifier'a erişim için
    );
  },
);

class BookmarkNotifier extends StateNotifier<BookmartState> {
  final BookmarkRepository _repo;
  final Ref _read;

  BookmarkNotifier(this._repo, this._read) : super(const BookmartState()) {
    load();
  }
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final items = await _repo.getAll();
      _apply(source: items);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addUrl(
    String url, {
    String? note,
    List<String>? tagNames,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final bookmarkId = await _repo.addFromUrl(url, note: note);
      if (tagNames != null && tagNames.isNotEmpty) {
        final tagNotifier = _read.read(tagProvider.notifier);
        final tagIds = <int>[];

        for (final name in tagNames) {
          final tag = await tagNotifier.getOrCreate(name);
          tagIds.add(tag.id);
        }
        await _repo.attachTag(bookmarkId, tagIds);
      }
      await load();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> delete(int id) async {
    await _repo.delete(id);
    await load();
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    _apply(source: state.items);
  }

  void clearError() => state = state.copyWith(error: null);

  // _apply fonksiyonu (düzeltildi)
  void _apply({required List<Bookmark> source}) {
    final String? q = state.searchQuery;

    // eğer query boş ise tüm listeyi göster
    if (q == null || q.trim().isEmpty) {
      state = state.copyWith(items: source, filtered: source, isLoading: false);
      return;
    }

    final String lower = q.toLowerCase();

    final List<Bookmark> filtered = source.where((b) {
      final titleContains = (b.title?.toLowerCase() ?? '').contains(lower);
      final domainContains = (b.domain?.toLowerCase() ?? '').contains(lower);
      final urlContains = (b.url?.toLowerCase() ?? '').contains(lower);
      return titleContains || domainContains || urlContains;
    }).toList();

    // Burada filtered'i state'e yazıyoruz — bu satır eksikti
    state = state.copyWith(items: source, filtered: filtered, isLoading: false);
  }
}
