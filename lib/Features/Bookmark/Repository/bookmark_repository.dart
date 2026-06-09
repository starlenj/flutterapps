import 'package:isar/isar.dart';
import 'package:todoapp/Core/Services/metadata_service.dart';
import 'package:todoapp/Core/Services/platform_service.dart';
import 'package:todoapp/Core/Services/timestamp_parser.dart';
import 'package:todoapp/Core/database/base.repository.dart';
import 'package:todoapp/Features/Bookmark/Model/bookmark_model.dart';
import 'package:todoapp/Features/Tags/Model/tag_model.dart';
import '../../../Core/database/isar_service.dart';

class BookmarkRepository extends BaseRepository<Bookmark> {
  final MetadataService _metadataService;
  final PlatformService _platformService;
  final TimestampParser _timestampParser;
  BookmarkRepository({
    MetadataService? metadata,
    PlatformService? platform,
    TimestampParser? timestamp_parser,
  }) : _metadataService = metadata ?? MetadataService(),
       _platformService = platform ?? PlatformService(),
       _timestampParser = timestamp_parser ?? TimestampParser();
  Future<int> addFromUrl(String url, {String? note}) async {
    final meta = await _metadataService.fetch(url);
    final platform = _platformService.detect(url);
    final timestampt = _timestampParser.parse(url);
    final bookMark = Bookmark(
      url: url,
      title: meta.title,
      tumbnailUrl: meta.image,
      domain: meta.domain,
      note: note,
      platform: platform,
      contentType: _inferContentType(platform),
      timestampSeconds: timestampt,
      createdAt: DateTime.now(),
      updatetAt: DateTime.now(),
    );
    return await save(bookMark);
  }

  ContentType _inferContentType(Platform platform) {
    switch (platform) {
      case Platform.youtube:
      case Platform.vimeo:
        return ContentType.video;
      case Platform.instagram:
      case Platform.tiktok:
        return ContentType.sort;
      case Platform.x:
        return ContentType.link;

      default:
        return ContentType.link;
    }
  }

  Future<List<Bookmark>> search(String query) async {
    final isar = await IsarService().db;
    final results = await isar.bookmarks
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .urlContains(query, caseSensitive: false)
        .findAll();
    return results;
  }

  Future<void> attachTag(int bookMarkId, List<int> tagIds) async {
    final isar = await IsarService().db;
    await isar.writeTxn(() async {
      final bookmark = await isar.bookmarks.get(bookMarkId);
      if (bookmark == null) return;

      for (final tagId in tagIds) {
        final tag = await isar.tags.get(tagId);
        if (tag != null) bookmark.tags.add(tag);
      }
      await bookmark.tags.save();
    });
  }

  BookmarkRepository._(
    this._metadataService,
    this._platformService,
    this._timestampParser,
  );
  static final instance = BookmarkRepository._(
    MetadataService(),
    PlatformService(),
    TimestampParser(),
  );
  Future<Bookmark?> loadBookmarkById(String id) async {
    final isar = await IsarService().db;

    // Eğer id int ise (Isar Id) bunu parse et
    final intId = int.tryParse(id);
    if (intId != null) {
      return await isar.bookmarks.get(intId);
    }

    // Eğer sen string/uuid tabanlı id kullanıyorsan, Bookmark içinde string id tutmak
    // gerekir; bu örnekte int id olduğundan null döndürüyoruz.
    return null;
  }
}
