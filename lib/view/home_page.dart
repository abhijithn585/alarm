import 'dart:async';
import 'package:alarm/controller/dbcontroller.dart';
import 'package:alarm/controller/location_provider.dart';
import 'package:alarm/service/weather_service.dart';
import 'package:alarm/view/add_alarm.dart';
import 'package:alarm/view/edit_alarm.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime dateTime = DateTime.now();
  late DateTime currentime;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePOsition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServiceProvider>(context, listen: false)
              .fetchWeatherDataByCity(city);
        }
      }
    });
    currentime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentime = DateTime.now();
      });
    });
    Provider.of<DbController>(context, listen: false).getAlarms();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherServiceProvider>(context);

    var currenttime = DateFormat('hh:mm:ss a').format(currentime);
    var currendate = DateFormat('EEE, d MMM').format(currentime);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAlarm(),
                ));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                  child: Column(
                children: [
                  Text(
                    "${weatherProvider.weather?.main?.temp?.toStringAsFixed(0) ?? 'N/A'}\u00B0C",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    currenttime,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                  Text(
                    currendate,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ],
              )),
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer<DbController>(
              builder: (context, value, child) {
                if (value.alarmlist.isEmpty) {
                  return const Center(
                    child: Text(
                      'empty',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: value.alarmlist.length,
                      itemBuilder: (context, index) {
                        final alarms = value.alarmlist[index];
                        String formattedTime =
                            DateFormat('hh:mm a').format(alarms.time!);

                        return Consumer<DbController>(
                          builder: (context, value, child) => Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${formattedTime}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white)),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditAlarm(
                                                              index: index),
                                                    ));
                                              },
                                              icon: Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () {
                                                value.deleteAlarm(index);
                                              },
                                              icon: Icon(Icons.delete))
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text('${alarms.title}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ));
  }
}