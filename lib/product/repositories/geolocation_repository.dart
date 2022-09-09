import 'package:geolocator/geolocator.dart';

import '../model/custom_error_model.dart';

class GeolocationRepository {
  Future<Position> getCurrentLocation() async {
    LocationPermission locationPermission;

    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }

    if (locationPermission == LocationPermission.deniedForever) {
      throw const CustomErrorModel(
        code: 'Exception',
        message: 'Location permissions are permanently denied, we cannot request permissions.',
        plugin: 'flutter_error/server_error',
      );
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }
}
