import 'dart:convert';

import 'package:conavigator/domain/location/location.actions.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

Future<LatLng?> _determinePositionUsingGeolocator() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  final loc = await Geolocator.getCurrentPosition();
  return LatLng(loc.latitude, loc.longitude);
}

Future<LatLng?> _determinePositionUsingGeoIp() async {
  final data = await http.get(Uri.parse("https://ipinfo.io/json"));
  if (data.statusCode != 200) {
    return null;
  }
  final String loc = (json.decode(data.body) as Map<String, dynamic>)["loc"] as String;
  final latlng = loc.split(",");
  return LatLng(double.parse(latlng[0]), double.parse(latlng[1]));
}

Future<LatLng> _determinePosition() async {
  final logger = Logger();

  try {
    return (await _determinePositionUsingGeolocator())!;
  } catch (e) {
    logger.w("Could not determine position using Geolocator: $e");
  }

  try {
    return (await _determinePositionUsingGeoIp())!;
  } catch (e) {
    logger.w("Could not determine position using GeoIP: $e");
  }

  return LatLng(54, 82);
}

initLocationSaga() sync* {
  final coords = Result<LatLng>();
  yield Call(_determinePosition, result: coords);
  yield Put(LocationUpdatedAction(coords: coords.value ?? LatLng(0, 0)));
}
