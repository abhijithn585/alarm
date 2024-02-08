import 'package:hive/hive.dart';
part 'alarm_model.g.dart';

@HiveType(typeId: 1)
class AlarmModel {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? description;
  @HiveField(2)
  DateTime? time;
  AlarmModel(
      {required this.description, required this.time, required this.title});
}
