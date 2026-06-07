import 'package:todoapp/Features/Bookmark/Model/bookmark_model.dart';

class BookmartState {
  final List<Bookmark> items;
  final List<Bookmark> filtered;
  final bool isLoading;
  final String? error;
  final String? searchQuery;

  const BookmartState({
    this.items = const [],
    this.filtered = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery,
  });

  BookmartState copyWith({
    List<Bookmark>? items,
    List<Bookmark>? filtered,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return BookmartState(
      items: items ?? this.items,
      filtered: filtered ?? this.filtered,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
