import 'package:hive_flutter/hive_flutter.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  int id = -1;
  @HiveField(0)
  String title = '';
  @HiveField(1)
  bool isCompelete = false;
  @HiveField(2)
  Priority priority = Priority.low;
  @HiveField(3)
  String description = '';
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  high,
  @HiveField(1)
  normal,
  @HiveField(2)
  low
}
