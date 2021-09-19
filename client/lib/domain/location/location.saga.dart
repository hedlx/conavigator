import 'package:conavigator/domain/location/location.actions.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux_saga/redux_saga.dart';
import 'dart:io' show Platform;

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
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

  return await Geolocator.getCurrentPosition();
}

initLocationSaga() sync* {
  if (!kIsWeb && (Platform.isLinux || Platform.isMacOS || Platform.isWindows)) {
    // TODO: Somehow detect location, maybe by IP or something like that
    yield Put(LocationUpdatedAction(coords: LatLng(54, 82)));
    return;
  }

  try {
    var coords = Result<Position>();

    yield Call(_determinePosition, result: coords);
    final res = coords.value;

    yield Put(LocationUpdatedAction(
        coords: LatLng(res?.latitude ?? 0, res?.longitude ?? 0)));
  } catch (e) {
    yield Put(LocationUpdatedAction(coords: LatLng(0, 0)));
  }
}
