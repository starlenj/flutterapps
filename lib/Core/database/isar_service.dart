import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../Features/Bookmark/Model/bookmark_model.dart';

class IsarService {
  static final IsarService _instance = IsarService._intarnal();
  factory IsarService() => _instance;
  IsarService._intarnal();

  Isar? _isar;

  Future<Isar> get db async {
    _isar ??= await _init();
    return _isar!;
  }

  Future<Isar> _init() async {
    final dir = await getApplicationSupportDirectory();
    return Isar.open([BookmarkSchema], directory: dir.path);
  }
}
