import 'package:todoapp/Features/Tags/Model/tag_model.dart';

class TagState {
  final List<Tag> tags;
  final bool isLoading;
  final String? error;

  const TagState({this.tags = const [], this.isLoading = false, this.error});

  TagState copyWith({List<Tag>? tags, bool? isLoading, String? error}) {
    return TagState(
      tags: tags ?? this.tags,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
