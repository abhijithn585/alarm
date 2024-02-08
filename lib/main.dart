import 'package:alarm/controller/dbcontroller.dart';
import 'package:alarm/controller/location_provider.dart';
import 'package:alarm/model/alarm_model.dart';
import 'package:alarm/service/weather_service.dart';
import 'package:alarm/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


 final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(AlarmModelAdapter().typeId)) {
    Hive.registerAdapter(AlarmModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => LocationProvider()),ChangeNotifierProvider(create: (context) => DbController(),),ChangeNotifierProvider(create: (context) => WeatherServiceProvider(),)],
            child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
