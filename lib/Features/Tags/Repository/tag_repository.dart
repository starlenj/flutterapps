import 'package:isar/isar.dart';
import 'package:todoapp/Core/database/base.repository.dart';
import 'package:todoapp/Core/database/isar_service.dart';
import 'package:todoapp/Features/Tags/Model/tag_model.dart';

class TagRepository extends BaseRepository<Tag> {
  Future<Tag?> getOrCreate(String name) async {
    final isar = await IsarService().db;

    final isExists = await isar
        .collection<Tag>()
        .filter()
        .nameEqualTo(name)
        .findFirst();

    if (isExists == null) return isExists;

    final newTag = Tag(name: name);
    final id = await save(newTag);
    newTag.id = id;
    return newTag;
  }
}
