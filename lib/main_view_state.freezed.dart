// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'main_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MainViewState {
  double get latetitude => throw _privateConstructorUsedError;
  double get longtitude => throw _privateConstructorUsedError;
  double get currentSpeed => throw _privateConstructorUsedError;
  bool get openOption => throw _privateConstructorUsedError;
  bool get openInformation => throw _privateConstructorUsedError;
  String get typeGoing => throw _privateConstructorUsedError;
  List<Marker> get listMarker => throw _privateConstructorUsedError;
  DirectionObject? get directionObject => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MainViewStateCopyWith<MainViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainViewStateCopyWith<$Res> {
  factory $MainViewStateCopyWith(
          MainViewState value, $Res Function(MainViewState) then) =
      _$MainViewStateCopyWithImpl<$Res>;
  $Res call(
      {double latetitude,
      double longtitude,
      double currentSpeed,
      bool openOption,
      bool openInformation,
      String typeGoing,
      List<Marker> listMarker,
      DirectionObject? directionObject});
}

/// @nodoc
class _$MainViewStateCopyWithImpl<$Res>
    implements $MainViewStateCopyWith<$Res> {
  _$MainViewStateCopyWithImpl(this._value, this._then);

  final MainViewState _value;
  // ignore: unused_field
  final $Res Function(MainViewState) _then;

  @override
  $Res call({
    Object? latetitude = freezed,
    Object? longtitude = freezed,
    Object? currentSpeed = freezed,
    Object? openOption = freezed,
    Object? openInformation = freezed,
    Object? typeGoing = freezed,
    Object? listMarker = freezed,
    Object? directionObject = freezed,
  }) {
    return _then(_value.copyWith(
      latetitude: latetitude == freezed
          ? _value.latetitude
          : latetitude // ignore: cast_nullable_to_non_nullable
              as double,
      longtitude: longtitude == freezed
          ? _value.longtitude
          : longtitude // ignore: cast_nullable_to_non_nullable
              as double,
      currentSpeed: currentSpeed == freezed
          ? _value.currentSpeed
          : currentSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      openOption: openOption == freezed
          ? _value.openOption
          : openOption // ignore: cast_nullable_to_non_nullable
              as bool,
      openInformation: openInformation == freezed
          ? _value.openInformation
          : openInformation // ignore: cast_nullable_to_non_nullable
              as bool,
      typeGoing: typeGoing == freezed
          ? _value.typeGoing
          : typeGoing // ignore: cast_nullable_to_non_nullable
              as String,
      listMarker: listMarker == freezed
          ? _value.listMarker
          : listMarker // ignore: cast_nullable_to_non_nullable
              as List<Marker>,
      directionObject: directionObject == freezed
          ? _value.directionObject
          : directionObject // ignore: cast_nullable_to_non_nullable
              as DirectionObject?,
    ));
  }
}

/// @nodoc
abstract class _$MainViewStateCopyWith<$Res>
    implements $MainViewStateCopyWith<$Res> {
  factory _$MainViewStateCopyWith(
          _MainViewState value, $Res Function(_MainViewState) then) =
      __$MainViewStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {double latetitude,
      double longtitude,
      double currentSpeed,
      bool openOption,
      bool openInformation,
      String typeGoing,
      List<Marker> listMarker,
      DirectionObject? directionObject});
}

/// @nodoc
class __$MainViewStateCopyWithImpl<$Res>
    extends _$MainViewStateCopyWithImpl<$Res>
    implements _$MainViewStateCopyWith<$Res> {
  __$MainViewStateCopyWithImpl(
      _MainViewState _value, $Res Function(_MainViewState) _then)
      : super(_value, (v) => _then(v as _MainViewState));

  @override
  _MainViewState get _value => super._value as _MainViewState;

  @override
  $Res call({
    Object? latetitude = freezed,
    Object? longtitude = freezed,
    Object? currentSpeed = freezed,
    Object? openOption = freezed,
    Object? openInformation = freezed,
    Object? typeGoing = freezed,
    Object? listMarker = freezed,
    Object? directionObject = freezed,
  }) {
    return _then(_MainViewState(
      latetitude: latetitude == freezed
          ? _value.latetitude
          : latetitude // ignore: cast_nullable_to_non_nullable
              as double,
      longtitude: longtitude == freezed
          ? _value.longtitude
          : longtitude // ignore: cast_nullable_to_non_nullable
              as double,
      currentSpeed: currentSpeed == freezed
          ? _value.currentSpeed
          : currentSpeed // ignore: cast_nullable_to_non_nullable
              as double,
      openOption: openOption == freezed
          ? _value.openOption
          : openOption // ignore: cast_nullable_to_non_nullable
              as bool,
      openInformation: openInformation == freezed
          ? _value.openInformation
          : openInformation // ignore: cast_nullable_to_non_nullable
              as bool,
      typeGoing: typeGoing == freezed
          ? _value.typeGoing
          : typeGoing // ignore: cast_nullable_to_non_nullable
              as String,
      listMarker: listMarker == freezed
          ? _value.listMarker
          : listMarker // ignore: cast_nullable_to_non_nullable
              as List<Marker>,
      directionObject: directionObject == freezed
          ? _value.directionObject
          : directionObject // ignore: cast_nullable_to_non_nullable
              as DirectionObject?,
    ));
  }
}

/// @nodoc

class _$_MainViewState implements _MainViewState {
  _$_MainViewState(
      {this.latetitude = 10.762622,
      this.longtitude = 106.660172,
      this.currentSpeed = 40,
      this.openOption = false,
      this.openInformation = false,
      this.typeGoing = 'Driving',
      final List<Marker> listMarker = const [],
      this.directionObject = null})
      : _listMarker = listMarker;

  @override
  @JsonKey()
  final double latetitude;
  @override
  @JsonKey()
  final double longtitude;
  @override
  @JsonKey()
  final double currentSpeed;
  @override
  @JsonKey()
  final bool openOption;
  @override
  @JsonKey()
  final bool openInformation;
  @override
  @JsonKey()
  final String typeGoing;
  final List<Marker> _listMarker;
  @override
  @JsonKey()
  List<Marker> get listMarker {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listMarker);
  }

  @override
  @JsonKey()
  final DirectionObject? directionObject;

  @override
  String toString() {
    return 'MainViewState(latetitude: $latetitude, longtitude: $longtitude, currentSpeed: $currentSpeed, openOption: $openOption, openInformation: $openInformation, typeGoing: $typeGoing, listMarker: $listMarker, directionObject: $directionObject)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MainViewState &&
            const DeepCollectionEquality()
                .equals(other.latetitude, latetitude) &&
            const DeepCollectionEquality()
                .equals(other.longtitude, longtitude) &&
            const DeepCollectionEquality()
                .equals(other.currentSpeed, currentSpeed) &&
            const DeepCollectionEquality()
                .equals(other.openOption, openOption) &&
            const DeepCollectionEquality()
                .equals(other.openInformation, openInformation) &&
            const DeepCollectionEquality().equals(other.typeGoing, typeGoing) &&
            const DeepCollectionEquality()
                .equals(other.listMarker, listMarker) &&
            const DeepCollectionEquality()
                .equals(other.directionObject, directionObject));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(latetitude),
      const DeepCollectionEquality().hash(longtitude),
      const DeepCollectionEquality().hash(currentSpeed),
      const DeepCollectionEquality().hash(openOption),
      const DeepCollectionEquality().hash(openInformation),
      const DeepCollectionEquality().hash(typeGoing),
      const DeepCollectionEquality().hash(listMarker),
      const DeepCollectionEquality().hash(directionObject));

  @JsonKey(ignore: true)
  @override
  _$MainViewStateCopyWith<_MainViewState> get copyWith =>
      __$MainViewStateCopyWithImpl<_MainViewState>(this, _$identity);
}

abstract class _MainViewState implements MainViewState {
  factory _MainViewState(
      {final double latetitude,
      final double longtitude,
      final double currentSpeed,
      final bool openOption,
      final bool openInformation,
      final String typeGoing,
      final List<Marker> listMarker,
      final DirectionObject? directionObject}) = _$_MainViewState;

  @override
  double get latetitude => throw _privateConstructorUsedError;
  @override
  double get longtitude => throw _privateConstructorUsedError;
  @override
  double get currentSpeed => throw _privateConstructorUsedError;
  @override
  bool get openOption => throw _privateConstructorUsedError;
  @override
  bool get openInformation => throw _privateConstructorUsedError;
  @override
  String get typeGoing => throw _privateConstructorUsedError;
  @override
  List<Marker> get listMarker => throw _privateConstructorUsedError;
  @override
  DirectionObject? get directionObject => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MainViewStateCopyWith<_MainViewState> get copyWith =>
      throw _privateConstructorUsedError;
}