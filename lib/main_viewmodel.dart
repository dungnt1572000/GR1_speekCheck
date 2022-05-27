import 'package:dio/dio.dart';
import 'package:doan1/constant/accessTokenTest.dart';
import 'package:doan1/main.dart';
import 'package:doan1/src/apicalling/api_client.dart';
import 'package:doan1/src/apicalling/node.dart';
import 'package:doan1/src/direction_service/api_direction_client.dart';
import 'package:doan1/src/direction_service/direction_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final latetitudeProvider = StateProvider(
  (ref) => 10.762622,
);

final longtitudeProvider = StateProvider(
  (ref) => 106.660172,
);
final speedProvider = StateProvider(
  (ref) => 0.0,
);
final openCloseMenuProvider = StateProvider(
  (ref) => true,
);
final zoomProvider = StateProvider(
  (ref) => 13,
);

final findOptionProvider = StateProvider(
  (ref) => false,
);
final openDraggableInforProvider = StateProvider((ref) => false);

final openInformationProvider = StateProvider(
  (ref) => false,
);

class NodeStateNotifier extends StateNotifier<Node> {
  NodeStateNotifier(state) : super(state);

  void getNote(String coordinate) async {
    state = await RestClient(Dio()).fetchToGetNotes(
        'Basic ZHVuZ3BybzE1NzJrQGdtYWlsLmNvbTpuZ3V5ZW50YW5kdW5ncHJvMTU3MjAwMA==',
        coordinate);
  }
}

final noteProvider = StateNotifierProvider<NodeStateNotifier, Node>(
  (ref) => NodeStateNotifier(Node(
      attribution: '',
      copyright: '',
      generator: '',
      license: '',
      version: '',
      bounds: Bounds(minlat: 0.0, minlon: 0.0, maxlat: 0.0, maxlon: 0.0),
      elements: [])),
);

final markerNodeProvider = Provider<List<MapNode>>(
  (ref) {
    var listAll = ref.watch(noteProvider);
    var myList = listAll.elements.whereType<MapNode>().toList();
    return myList;
  },
);

final markerWayProvider = Provider<List<MapWay>>(
  (ref) {
    var listAll = ref.watch(noteProvider);
    var myList = listAll.elements.whereType<MapWay>().toList();
    return myList;
  },
);
final typeGoingProvider = StateProvider(
  (ref) => 'Driving',
);

class MarkerNotifier extends StateNotifier<List<Marker>> {
  MarkerNotifier(List<Marker> state) : super(state);

  void addMarker(Marker marker) {
    if (state.length > 2) {
      state = [];
    }
    state = [...state, marker];
  }

  void addAllMarker(List<Marker> listMarker) {
    state = listMarker;
  }

  void deleteMarker(LatLng latLng) {
    state = state
        .where((element) =>
            element.position.longitude != latLng.longitude &&
            element.position.latitude != latLng.latitude)
        .toList();
  }

  void deleteAllMarker() {
    state = [];
  }
}

final markerProvider = StateNotifierProvider<MarkerNotifier, List<Marker>>(
  (ref) {
    return MarkerNotifier([]);
  },
);

class DirectionNotifier extends StateNotifier<DirectionObject> {
  DirectionNotifier(DirectionObject state) : super(state);

  void getDirectionObjDriving(String distance) async {
    DirectionsClient(Dio())
        .getDirectionDriving(
            distance, accessToken, 'maxspeed', 'geojson', 'full')
        .then((value) {
      myListLatLng = value.routes[0].geometry.coordinates
          .map((e) => LatLng(e[1], e[0]))
          .toList();
      state = value;
    });
  }

  void getDirectionObjWalking(String distance) async {
    DirectionsClient(Dio())
        .getDirectionWalking(
            distance, accessToken, 'maxspeed', 'geojson', 'full')
        .then((value) {
      myListLatLng = value.routes[0].geometry.coordinates
          .map((e) => LatLng(e[1], e[0]))
          .toList();
      state = value;
    });
  }
}

final directionsProvider =
    StateNotifierProvider<DirectionNotifier, DirectionObject>((ref) =>
        DirectionNotifier(
            DirectionObject(uuid: '', waypoints: [], routes: [], code: '')));
