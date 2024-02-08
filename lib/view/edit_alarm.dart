import 'package:alarm/controller/dbcontroller.dart';
import 'package:alarm/model/alarm_model.dart';
import 'package:alarm/view/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditAlarm extends StatefulWidget {
  const EditAlarm({super.key, required this.index});

  @override
  State<EditAlarm> createState() => _EditAlarmState();

  final int index;
}

class _EditAlarmState extends State<EditAlarm> {
  String? dateTime;
  bool repeat = false;

  DateTime? notificationtime;

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Add Alarm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: CupertinoDatePicker(
              showDayOfWeek: true,
              minimumDate: DateTime.now(),
              dateOrder: DatePickerDateOrder.dmy,
              onDateTimeChanged: (va) {
                dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(va);
                print(dateTime);
              },
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: titlecontroller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: descriptioncontroller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'description'),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                editAlarms(
                  widget.index,
                );
                Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
              child: const Text("Set Alaram")),
        ],
      ),
    );
  }

  editAlarms(index) {
    final String title = titlecontroller.text.trim();
    final String description = descriptioncontroller.text.trim();
    final pro = Provider.of<DbController>(context, listen: false);
    DateTime alarmTime = DateTime.parse(dateTime!);
    AlarmModel alarm = AlarmModel(
      description: description,
      time: alarmTime,
      title: title,
    );
    pro.editAlarm(index, alarm);
    print(pro.alarmlist);
  }
}