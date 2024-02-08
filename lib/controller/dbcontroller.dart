import 'package:alarm/model/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DbController extends ChangeNotifier {
  List<AlarmModel> alarmlist = [];

  addAlarm(AlarmModel alarm) async {
    final alarmbox = await Hive.openBox<AlarmModel>('alarmbox');
    alarmlist.add(alarm);
    alarmbox.add(alarm);
    notifyListeners();
  }

  getAlarms() async {
    final alarmbox = await Hive.openBox<AlarmModel>('alarmbox');
    alarmlist.clear();
    alarmlist = alarmbox.values.toList();
    notifyListeners();
  }

  deleteAlarm(int index) async {
    final alarmbox = await Hive.openBox<AlarmModel>('alarmbox');
    await alarmbox.deleteAt(index);
    notifyListeners();
    await getAlarms();
  }

  Future<void> editAlarm(index, AlarmModel value) async {
    final alarmbox = await Hive.openBox<AlarmModel>('alarmbox');
    alarmlist.clear();
    alarmlist.addAll(alarmbox.values);
    notifyListeners();
    alarmbox.putAt(index, value);
    getAlarms();
  }
}