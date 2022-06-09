import 'package:dio/dio.dart';
import 'package:doan1/constant/accessTokenTest.dart';
import 'package:doan1/main_view_state.dart';
import 'package:doan1/src/direction_service/api_direction_client.dart';
import 'package:doan1/src/searching_service/api_search_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class MainViewModel extends StateNotifier<MainViewState> {
  MainViewModel(MainViewState state) : super(state);

  void updateLatLong(double late, double long) {
    state = state.copyWith(latetitude: late, longtitude: long);
  }

  void updateCurrentSpeed(double speed) {
    state = state.copyWith(currentSpeed: speed*3.6);
  }

  void openInformation(bool value) {
    state = state.copyWith(openInformation: value);
  }

  void openOption(bool value) {
    state = state.copyWith(openOption: value);
  }

  void openWannago(bool value) {
    state = state.copyWith(openWannagoListPoint: value);
  }

  void openStarting(bool value) {
    state = state.copyWith(openStartingListPoint: value);
  }

  void changeTypeGoing(String value) {
    state = state.copyWith(typeGoing: value);
  }

  void addMarker({required Marker marker, int? position}) async {
    if (state.listMarker.length < 2) {
      if (position != null) {
        state = state.copyWith(
          listMarker: [
            for (int i = 0; i < state.listMarker.length; i++)
              if (i == position) marker,
            ...state.listMarker
          ],
        );
      } else {
        state = state.copyWith(listMarker: [...state.listMarker, marker]);
      }
    } else {
      var list = state.listMarker.take(2).toList();
      print(list);
     state = state.copyWith(
       listMarker: list
     );
    }

    Logger().e(state.listMarker.length);
  }

  void deleteAllMarkerandReset() {
    state =
        state.copyWith(listMarker: [], listLatLng: [], openInformation: false);
  }

  Future<bool> getDirectionObjDriving(String distance) async {
    try {
      DirectionsClient(Dio())
          .getDirectionDriving(
              distance, accessToken, 'maxspeed', 'geojson', 'full')
          .then((value) {
        state = state.copyWith(
            openInformation: true,
            directionObject: value,
            listLatLng: value.routes[0].geometry.coordinates
                .map((e) => LatLng(e[1], e[0]))
                .toList());
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
        state = state.copyWith(
            directionObject: value,
            listLatLng: value.routes[0].geometry.coordinates
                .map((e) => LatLng(e[1], e[0]))
                .toList());
      });
      return true;
    } on Exception catch (err) {
      Logger().e(err.toString());
      return false;
    }
  }

  void deleteListLatLng() {
    state = state.copyWith(listLatLng: []);
  }

  void getSearchingObject(String location) async {
    SearchingClient(Dio())
        .fetchToGetSearchingObject(
          location,
          accessToken,
        )
        .then(
          (value) => state = state.copyWith(searchingObject: value),
        );
  }
}
