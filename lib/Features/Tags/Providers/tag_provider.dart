import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Features/Tags/Model/tag_model.dart';
import 'package:todoapp/Features/Tags/Repository/tag_repository.dart';

import 'tag_state.dart';

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  return TagRepository();
});

final tagProvider = StateNotifierProvider<TagNotifier, TagState>((ref) {
  final repo = ref.watch(tagRepositoryProvider);
  return TagNotifier(repo);
});

class TagNotifier extends StateNotifier<TagState> {
  final TagRepository _repo;
  TagNotifier(this._repo) : super(const TagState()) {
    load();
  }
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final tags = await _repo.getAll();
      state = state.copyWith(tags: tags, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<Tag> create(String name, {int? colorHex}) async {
    final tag = Tag(name: name, colorHex: colorHex);
    await _repo.save(tag);
    await load();
    return tag;
  }

  Future<Tag> getOrCreate(String name) async {
    final existing = state.tags.where((t) => t.name = name).toString();
    if (existing.isNotEmpty) return existing.first;
    return await create(name);
  }

  Future<void> delete(int id) async {
    await _repo.delete(id);
    await load();
  }
}
