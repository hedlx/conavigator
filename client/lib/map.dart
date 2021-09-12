import 'package:conavigator/domain/location/location.reducer.dart';
import 'package:conavigator/store/app.state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:latlong2/latlong.dart';

class UberMap extends StatelessWidget {
  final bool isLoading;
  final LatLng center;
  const UberMap({Key? key, this.isLoading = false, required this.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return FlutterMap(
      options: MapOptions(
        center: center,
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: [],
        ),
      ],
    );
  }
}

class UberMapContainer extends StatelessWidget {
  const UberMapContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LocationState>(
        builder: (context, state) {
          return UberMap(center: state.location, isLoading: state.isLoading);
        },
        converter: (store) => store.state.location);
  }
}
