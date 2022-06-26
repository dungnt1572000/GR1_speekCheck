import 'package:dio/dio.dart';
import 'package:doan1/constant/access_token_test.dart';
import 'package:doan1/constant/all_of_enum.dart';
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
    state = state.copyWith(currentSpeed: speed * 3.6);
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

  void addMarker({
    required Marker marker,
  }) {
    state = state.copyWith(listMarker: [...state.listMarker, marker]);
    Logger().e(state.listMarker.length);
  }

  void deleteAllMarkerandReset() {
    state =
        state.copyWith(listMarker: [], listLatLng: [], openInformation: false);
  }

  Future<void> getDirectionObjDriving(String distance) async {
    try {
      state = state.copyWith(status: LoadingStatus.inProcess);
      DirectionsClient(Dio())
          .getDirectionDriving(
              distance, accessToken, 'maxspeed', 'geojson', 'full')
          .then(
        (value) {
          state = state.copyWith(
              openInformation: true,
              directionObject: value,
              listLatLng: value.routes[0].geometry.coordinates
                  .map(
                    (e) => LatLng(e[1], e[0]),
                  )
                  .toList());
        },
      );
      state = state.copyWith(status: LoadingStatus.success);
    } on Exception catch (err) {
      state = state.copyWith(status: LoadingStatus.error);
      Logger().e(err.toString());
    }
  }

  Future getDirectionObjWalking(String distance) async {
    try {
      state = state.copyWith(status: LoadingStatus.inProcess);
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
      state = state.copyWith(status: LoadingStatus.success);
    } on Exception catch (err) {
      Logger().e(err.toString());
      state = state.copyWith(status: LoadingStatus.error);
    }
  }

  void deleteListLatLng() {
    state = state.copyWith(listLatLng: []);
  }

  Future getSearchingObject(String location) async {
    try {
      state = state.copyWith(status: LoadingStatus.inProcess);
      SearchingClient(Dio())
          .fetchToGetSearchingObject(
            location,
            accessToken,
          )
          .then(
            (value) => state = state.copyWith(searchingObject: value),
          );
    } catch (error) {
      state = state.copyWith(status: LoadingStatus.error);
    }
  }
}
