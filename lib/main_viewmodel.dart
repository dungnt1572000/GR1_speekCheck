import 'package:dio/dio.dart';
import 'package:doan1/constant/accessTokenTest.dart';
import 'package:doan1/main.dart';
import 'package:doan1/main_view_state.dart';
import 'package:doan1/src/direction_service/api_direction_client.dart';
import 'package:doan1/src/direction_service/direction_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

final latetitudeProvider = StateProvider(
  (ref) => 10.762622,
);

final longtitudeProvider = StateProvider(
  (ref) => 106.660172,
);
final speedProvider = StateProvider(
  (ref) => 0.0,
);

final findOptionProvider = StateProvider(
  (ref) => false,
);

final openInformationProvider = StateProvider(
  (ref) => false,
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

class MainViewModel extends StateNotifier<MainViewState> {
  MainViewModel(MainViewState state) : super(state);

  void updateLatLong(double late, double long) {
    state.copyWith(latetitude: late, longtitude: long);
  }

  void openInformation(bool value) {
    state.copyWith(openInformation: value);
  }

  void openOption(bool value) {
    state.copyWith(openOption: value);
  }

  void changeTypeGoing(String value) {
    state.copyWith(typeGoing: value);
  }

  void addMarker(Marker marker) {
    if (state.listMarker.length > 2) {
      state.copyWith(
        listMarker: [],
      );
    }
    state.copyWith(listMarker: [...state.listMarker, marker]);
  }

  void deleteAllMarker() {
    state.copyWith(listMarker: []);
  }

  Future<bool> getDirectionObjDriving(String distance) async {
    try {
      DirectionsClient(Dio())
          .getDirectionDriving(
              distance, accessToken, 'maxspeed', 'geojson', 'full')
          .then((value) {
        myListLatLng = value.routes[0].geometry.coordinates
            .map((e) => LatLng(e[1], e[0]))
            .toList();
        state.copyWith(directionObject: value);
      });
      return true;
    } on Exception catch (err) {
      Logger().e(err.toString());
      return false;
    }
  }

  Future<bool> getDirectionObjWalking(String distance) async {
    try {
      DirectionsClient(Dio())
          .getDirectionWalking(
              distance, accessToken, 'maxspeed', 'geojson', 'full')
          .then((value) {
        myListLatLng = value.routes[0].geometry.coordinates
            .map((e) => LatLng(e[1], e[0]))
            .toList();
        state.copyWith(directionObject: value);
      });
      return true;
    } on Exception catch (err) {
      Logger().e(err.toString());
      return false;
    }
  }
}
