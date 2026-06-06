import 'package:isar/isar.dart';
import 'package:todoapp/Core/database/base.repository.dart';
import 'package:todoapp/Core/database/isar_service.dart';
import 'package:todoapp/Features/Bookmark/Model/bookmark_model.dart';

class BookmarkRepository extends BaseRepository<Bookmark> {
  Future<List<Bookmark>> search(String query) async {
    final col = await collection;
    return await col
        .filter()
        .titleContains(query, caseSensitive: false)
        .findAll();
  }
}
