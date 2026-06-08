import 'package:isar/isar.dart';
import 'package:todoapp/Core/database/isar_service.dart';

abstract class BaseRepository<T> {
  Future<IsarCollection<T>> get collection async {
    final isar = await IsarService().db;
    return isar.collection<T>();
  }

  Future<List<T>> getAll() async {
    final col = await collection;
    return await col.where().findAll();
  }

  Future<T?> getById(Id id) async {
    final col = await collection;
    return await col.get(id);
  }

  Future<int> save(T item) async {
    final isar = await IsarService().db;
    return await isar.writeTxn<int>(() async {
      return await isar.collection<T>().put(item);
    });
  }

  Future<void> delete(int id) async {
    final isar = await IsarService().db;
    await isar.writeTxn(() async {
      final col = isar.collection<T>();
      await col.delete(id);
    });
  }
}
