import 'package:conavigator/domain/location/location.actions.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:redux_saga/redux_saga.dart';
import 'dart:io' show Platform;

initLocationSaga() sync* {
  if (Platform.isLinux) {
    // TODO: Somehow detect location, maybe by IP or something like that
    yield Put(LocationUpdatedAction(coords: LatLng(42, 42)));
    return;
  }

  try {
    final location = Location();
    var coords = Result();

    yield Call(location.getLocation, result: coords);
    final res = coords.value;

    yield Put(LocationUpdatedAction(
        coords: LatLng(res?.latitude ?? 0, res?.longitude ?? 0)));
  } catch (e) {
    yield Put(LocationUpdatedAction(coords: LatLng(0, 0)));
  }
}
