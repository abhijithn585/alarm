import 'package:alarm/controller/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? currentPosition;
  final LocationService _locationService = LocationService();
  Placemark? currentLocationName;
// ask the permission
  Future<void> determinePOsition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      currentPosition = null;
      notifyListeners();
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        currentPosition = null;
        notifyListeners();
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      currentPosition = null;
      notifyListeners();
      return;
    }

    currentPosition = await Geolocator.getCurrentPosition();
    print(currentPosition);
    currentLocationName =
        await _locationService.getLocationName(currentPosition);
    print(currentLocationName);
    notifyListeners();
  }
}
