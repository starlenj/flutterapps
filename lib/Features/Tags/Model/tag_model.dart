import 'package:isar/isar.dart';

part 'tag_model.g.dart';

@collection
class Tag {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;

  int? colormex;

  DateTime createdAt = DateTime.now();
  Tag({this.colormex, required this.name});
}
