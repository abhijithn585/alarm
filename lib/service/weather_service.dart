import 'dart:convert';

import 'package:alarm/model/weather_model.dart';
import 'package:alarm/secrets/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherServiceProvider extends ChangeNotifier {
  WeatherModel? weather;
  bool isloading = false;
  String error = "";
  Future<void> fetchWeatherDataByCity(String city) async {
    isloading = true;
    error = "";
    // https://api.openweathermap.org/data/2.5/weather?q=dubai&appid=31ff0471651d915b8391169af20ce06d

    try {
      final apiUrl =
          "${APIEndPoints().cityUrl}${city}&appid=${APIEndPoints().apikey}${APIEndPoints().unit}";
      print(apiUrl);
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        weather = WeatherModel.fromJson(data);
        print(weather!.name);
        notifyListeners();
      } else {
        error = "failed to load data";
      }
    } catch (e) {
      error = "Failed to load data $e";
    } finally {
      isloading = false;
      notifyListeners();
    }
  }
}
