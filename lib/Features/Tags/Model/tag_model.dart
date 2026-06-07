import 'package:isar/isar.dart';

part 'tag_model.g.dart';

@collection
class Tag {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;

  int? colorHex;

  DateTime createdAt = DateTime.now();
  Tag({this.colorHex, required this.name});
}
