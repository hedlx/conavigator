import 'dart:convert';
import 'dart:io';

import 'package:latlong2/latlong.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

import 'globals.dart';


class OsmXml {
  final nodes = <int, LatLng>{};
  final nextNodes = <int, Set<int>>{};
  int _counter = 0;

  static Future<OsmXml> fromFile(String filePath) async {
    final result = OsmXml();

    var start = DateTime.now();
    await File(filePath)
        .openRead()
        .transform(gzip.decoder)
        .transform(utf8.decoder)
        .toXmlEvents()
        .normalizeEvents()
        .selectSubtreeEvents((event) => event.name == "node" || event.name == "way")
        .toXmlNodes()
        .flatten()
        .forEach(result._addXmlNode);
    final took = DateTime.now().difference(start);

    // TODO: clean up unused nodes

    logger.i(
        "Took: $took\n"
        "Total nodes: ${result.nodes.length}\n"
        "Total nextNodes: ${result.nextNodes.length}\n"
        "Counter: ${result._counter}"
    );

    return result;
  }

  _addXmlNode(XmlNode node) {
    final elem = node as XmlElement;
    // TODO: proper null check / int parse check
    switch (elem.name.local) {
      case "node":
        final id = int.parse(elem.getAttribute("id")!);
        final lat = double.parse(elem.getAttribute("lat")!);
        final lon = double.parse(elem.getAttribute("lon")!);
        nodes[id] = LatLng(lat, lon);

        if (_counter++ < 10) {
          logger.d("$elem");
        }

        break;
      case "way":
        var ok = false;

        final wayId = int.parse(elem.getAttribute("id")!);
        final wayNodes = <int>[];
        for (final q in elem.childElements) {
          switch (q.name.local) {
            case "nd":
              wayNodes.add(int.parse(q.getAttribute("ref")!));
              break;
            case "tag":
              final k = q.getAttribute("k")!;
              final v = q.getAttribute("v")!;
              // TODO: handle other walkable way types
              if (k == "highway" && v == "footway") {
                ok = true;
              }
              break;
          }
        }

        if (!ok) {
          return;
        }

        if (_counter++ < 10) {
          logger.d("$wayNodes");
        }

        int? prev;
        for (final nd in wayNodes) {
          if (prev != null) {
            nextNodes.putIfAbsent(prev, () => {}).add(nd);
            nextNodes.putIfAbsent(nd, () => {}).add(prev);
          }
          prev = nd;
        }
    }
  }
}