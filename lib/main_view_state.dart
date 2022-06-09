import 'package:doan1/src/direction_service/direction_object.dart';
import 'package:doan1/src/searching_service/searching_object.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
part 'main_view_state.freezed.dart';

@freezed
class MainViewState with _$MainViewState {
  factory MainViewState({
    @Default(10.762622) double latetitude,
    @Default(106.660172) double longtitude,
    @Default(0) double currentSpeed,
    @Default(false) bool openOption,
    @Default(false) bool openInformation,
    @Default('Driving') String typeGoing,
    @Default([]) List<Marker> listMarker,
    @Default([]) List<LatLng> listLatLng,
    @Default(null) DirectionObject? directionObject,
    @Default(false) openWannagoListPoint,
    @Default(false) openStartingListPoint,
    @Default(null) SearchingObject? searchingObject,
  }) = _MainViewState;
}
