import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Features/Bookmark/Model/bookmark_model.dart';
import 'package:todoapp/Features/Bookmark/Providers/bookmart_state.dart';
import 'package:todoapp/Features/Bookmark/Repository/bookmark_repository.dart';

class BookmarkNotifier extends StateNotifier<BookmartState> {
  final BookmarkRepository _repo;

  BookmarkNotifier(this._repo) : super(const BookmartState()) {
    load();
  }
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final items = await _repo.getAll();
      _apply(items);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addUrl(String url, {String? note}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.addFromUrl(url, note);
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
    _apply(state.items);
  }

  void clearError() => state = state.copyWith(error: null);

  void _apply(List<Bookmark> source) {
    final q = state.searchQuery;
    if (q == null || q.isEmpty) {
      state = state.copyWith(items: source, filtered: source, isLoading: false);
      return;
    }
    final lower = q.toLowerCase();
    final filtered = source.where((b) {
      return (b.title?.toLowerCase().contains(lower) ?? false) ||
          (b.domain?.toLowerCase().contains(lower) ?? false) ||
          b.url.toLowerCase().contains(lower);
    });
  }
}
