import "package:isar/isar.dart";
import "package:todoapp/Features/Tags/Model/tag_model.dart";

part 'bookmark_model.g.dart';

enum ContentType {
  link,
  video,
  sort,
  profile,
  article,
  blog,
  podcast,
  audio,
  ebook,
  document,
  presentation,
  spreadsheet,
  spreadsheetOther,
}

enum Platform { youtube, instagram, x, vimeo, tiktok, web, other }

enum SyncStatus { local, synced, pendingUpload, pendingDelete }

@collection
class Bookmark {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String url;

  String? userId;
  String? title;
  String? tumbnailUrl;
  String? domain;
  String? note;
  @enumerated
  ContentType contentType = ContentType.link;

  @enumerated
  Platform platform = Platform.web;

  int? timestampSeconds;
  bool isPinned = false;
  bool isArchived = false;

  @enumerated
  SyncStatus syncStatus = SyncStatus.local;

  DateTime? createdAt = DateTime.now();
  DateTime? updatetAt = DateTime.now();

  final tags = IsarLink<Tag>();

  Bookmark({
    required this.url,
    this.userId,
    this.title,
    this.tumbnailUrl,
    this.domain,
    this.note,
    this.contentType = ContentType.link,
    this.platform = Platform.web,
    this.timestampSeconds,
    this.isPinned = false,
    this.isArchived = false,
    this.syncStatus = SyncStatus.local,
    this.createdAt,
    this.updatetAt,
  });
}
