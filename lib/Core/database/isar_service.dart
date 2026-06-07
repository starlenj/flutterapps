import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoapp/Features/Tags/Model/tag_model.dart';
import '../../Features/Bookmark/Model/bookmark_model.dart';

class IsarService {
  static final IsarService _instance = IsarService._intarnal();
  factory IsarService() => _instance;
  IsarService._intarnal();
  Isar? _isar;

  Future<Isar> get db async {
    _isar ??= await _init();
    if (_isar == null)
      throw Exception('Isar not initialized. Call IsarService().init() first.');
    return _isar!;
    return _isar!;
  }

  Future<void> init() async {
    if (_isar != null) return;
    final dir = await getApplicationSupportDirectory();
    if (kIsWeb) {
      _isar = await Isar.open(
        [BookmarkSchema, TagSchema], // <-- Eksik olan kısım burası
        directory: dir.path, // Web değilse bu satır da gereklidir
        inspector: true,
      );
    } else {
      _isar = await Isar.open(
        [BookmarkSchema, TagSchema],
        directory: dir.path,
        inspector: true,
      );
    }
  }

  Future<Isar> _init() async {
    final dir = await getApplicationSupportDirectory();
    return Isar.open([BookmarkSchema, TagSchema], directory: dir.path);
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
