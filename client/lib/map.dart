import 'package:conavigator/domain/location/location.reducer.dart';
import 'package:conavigator/globals.dart';
import 'package:conavigator/osmxml.dart';
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

    final polyLines = <Polyline>[];
    final osmXml = globalOsmXml;
    if (osmXml != null) {
      for (final entry in osmXml.nextNodes.entries) {
        final from = osmXml.nodes[entry.key]!;
        for (final to in entry.value) {
          polyLines.add(
              Polyline(
                color: Colors.black,
                strokeWidth: 2,
                points: [
                  from, osmXml.nodes[to]!,
                ],
              )
          );
        }
      }
    }

    return FlutterMap(
      options: MapOptions(
        center: center,
        zoom: 13.0,
        onTap: (point) {
        },
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: [],
        ),
        PolylineLayerOptions(
          polylines: polyLines,
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
