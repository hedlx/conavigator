import 'package:latlong2/latlong.dart';

class LocationUpdatedAction {
  final LatLng coords;

  LocationUpdatedAction({required this.coords});
}
