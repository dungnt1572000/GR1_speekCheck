import 'dart:async';

import 'package:doan1/main_viewmodel.dart';
import 'package:doan1/splash_screen.dart';
import 'package:doan1/src/direction_service/direction_object.dart';
import 'package:doan1/src/searching_service/searching_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

import 'main_view_state.dart';

final _provider =
    StateNotifierProvider.autoDispose<MainViewModel, MainViewState>(
  (ref) => MainViewModel(
    MainViewState(),
  ),
);

void main() => runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  MainViewModel get _viewmodel => ref.read(_provider.notifier);
  var distance = '';
  FocusNode forcusNode1 = FocusNode();
  FocusNode forcusNode2 = FocusNode();
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _presentLocationController =
      TextEditingController();
  final TextEditingController _wannagoLocationController =
      TextEditingController();
  Location location = Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forcusNode1.addListener(() {
      Logger().w('listener');
    });
    forcusNode2.addListener(() {
      Logger().w('listener');
    });
  }

  var i = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    forcusNode1.dispose();
    forcusNode2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    i++;
    print('Build so lan $i');
    // TODO: implement build
    final state = ref.watch(_provider);
    double latitude = state.latetitude;
    double longtitude = state.longtitude;
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    List<Marker> _marker = state.listMarker;
    bool uIcheckfindProvider = state.openOption;
    bool openInfor = state.openInformation;
    String typeGoing = state.typeGoing;
    DirectionObject? directionsObject = state.directionObject;
    var curSpeed = state.currentSpeed;
    List<LatLng> myListLatLng = state.listLatLng;
    int? _getCurrentSpeed() {
      int sml = 0;
      var arrSpeed = directionsObject!.routes[0].legs[0].annotation.maxspeed;
      for (int i = 0; i < arrSpeed.length; i++) {
        if (arrSpeed[i].unknown == true) {
          arrSpeed.insert(
            i,
            Maxspeed(
              speed: 40,
              unit: 'km/h',
              unknown: null,
            ),
          );
          arrSpeed.removeAt(i + 1);
        }
      }
      // di ve dong bac
      if (myListLatLng[0].longitude < myListLatLng[1].longitude &&
          myListLatLng[0].latitude < myListLatLng[1].latitude) {
        sml = directionsObject.routes[0].geometry.coordinates.indexWhere(
            (element) => latitude <= element[1] && longtitude < element[0]);
        Logger().v(sml);
      }
      // phia dong nam
      if (myListLatLng[0].longitude < myListLatLng[1].longitude &&
          myListLatLng[0].latitude > myListLatLng[1].latitude) {
        sml = directionsObject.routes[0].geometry.coordinates.indexWhere(
            (element) => latitude >= element[1] && longtitude <= element[0]);
        Logger().v(sml);
      }
      // phia tay bac
      if (myListLatLng[0].longitude > myListLatLng[1].longitude &&
          myListLatLng[0].latitude < myListLatLng[1].latitude) {
        //
        sml = directionsObject.routes[0].geometry.coordinates.indexWhere(
            (element) => latitude >= element[1] && longtitude < element[0]);
        Logger().v(sml);
      }
      // tay nam
      else {
        sml = directionsObject.routes[0].geometry.coordinates.indexWhere(
            (element) => latitude >= element[1] && longtitude >= element[0]);
        Logger().v(sml);
      }
      if (sml < 0) {
        return 40;
      }
      return arrSpeed[sml].speed;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _serviceEnabled = await location.serviceEnabled();
          if (!_serviceEnabled) {
            _serviceEnabled = await location.requestService();
            if (!_serviceEnabled) {
              return;
            }
          }

          _permissionGranted = await location.hasPermission();
          if (_permissionGranted == PermissionStatus.denied) {
            _permissionGranted = await location.requestPermission();
            if (_permissionGranted != PermissionStatus.granted) {
              return;
            }
          }

          _locationData = await location.getLocation();

          _viewmodel.updateLatLong(
              _locationData.latitude!, _locationData.longitude!);

          final GoogleMapController controller = await _controller.future;
          await controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target:
                    LatLng(_locationData.latitude!, _locationData.longitude!),
                zoom: 11.15,
              ),
            ),
          );
        },
        child: const Icon(Icons.my_location),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.loose,
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longtitude), zoom: 11.5),
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              markers: Set.of(_marker),
              onMapCreated: (GoogleMapController controller) {
                return _controller.complete(controller);
              },
              onTap: _handleTap,
              polylines: {
                Polyline(
                  color: Colors.blueAccent,
                  width: 3,
                  polylineId: const PolylineId('halo'),
                  points: myListLatLng,
                )
              },
            ),
            AnimatedCrossFade(
              firstChild: _buildSearchingBar(state),
              secondChild: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(
                      side: BorderSide(color: Colors.blue),
                    ),
                    primary: Colors.white),
                onPressed: () {
                  _viewmodel.openOption(!state.openOption);
                },
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.blue,
                ),
              ),
              crossFadeState: uIcheckfindProvider
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 500),
            ),
            openInfor == true && myListLatLng.isNotEmpty
                ? Positioned(
                    right: 8,
                    top: 315,
                    child: SizedBox(
                      width: 125,
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 12,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(Icons.speed,color: Colors.lightBlue,),
                                  Text(state.currentSpeed.toString() + 'km/h',style: const TextStyle(color: Colors.lightBlue))
                                ],
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 12,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(Icons.access_time_rounded,color: Colors.lightBlue,),
                                  Text(state.directionObject == null
                                      ? 'Unknown'
                                      : '${(state.directionObject!.routes[0].duration / 60).toStringAsFixed(2)} min',style: const TextStyle(color: Colors.lightBlue),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            if (openInfor == true && myListLatLng.isNotEmpty)
              DraggableScrollableSheet(
                initialChildSize: 0.4,
                maxChildSize: 0.5,
                minChildSize: 0.03,
                builder: (context, scrollController) => ListView(
                  controller: scrollController,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 15,
                          child: SizedBox(
                            width: 125,
                            child: TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.directions_run_rounded),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Walking',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                _viewmodel.changeTypeGoing('Run');
                                _viewmodel.getDirectionObjWalking(distance);
                              },
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 15,
                          child: SizedBox(
                            width: 125,
                            child: TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.directions_car_rounded),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Driving',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                _viewmodel.changeTypeGoing('Driving');
                                _viewmodel.getDirectionObjDriving(distance);
                              },
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 15,
                          child: SizedBox(
                            width: 125,
                            child: TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.directions_bike_rounded),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Bike',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                _viewmodel.changeTypeGoing('Driving');
                                _viewmodel.getDirectionObjDriving(distance);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                          color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Kind of Driving: $typeGoing',
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 28,
                                fontWeight: FontWeight.normal),
                          ),
                          const Divider(),
                          Text(
                            'Current Speed: ${curSpeed.toStringAsFixed(2)} km/h',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Divider(),
                          Text(
                            'Starting point: ${directionsObject!.waypoints[0].name}',
                            style: const TextStyle(
                                color: Colors.lightBlue, fontSize: 20),
                          ),
                          Text(
                            'Ends point: ${directionsObject.waypoints[1].name}',
                            style: const TextStyle(
                                color: Colors.lightBlue, fontSize: 20),
                          ),
                          Text(
                            'Abroad: ${directionsObject.routes[0].countryCrossed}',
                            style: const TextStyle(
                                color: Colors.lightBlue, fontSize: 17),
                          ),
                          const Divider(height: 12),
                          Text(
                            'Accept Current Speed in this Way: ${_getCurrentSpeed() ?? 40}km/h',
                            style: const TextStyle(
                                color: Colors.lightBlue, fontSize: 20),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            else
              const SizedBox()
          ],
        ),
      ),
    );
  }

  _handleTap(LatLng latln) {
    print('on tab');
    var _listmarker = ref.watch(_provider).listMarker;
    if (_listmarker.length < 2) {
      _viewmodel.addMarker(
        marker: Marker(
          markerId: MarkerId(latln.toString()),
          position: latln,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    } else {
      _viewmodel.deleteAllMarkerandReset();
    }
  }

  Widget _buildSearchingBar(MainViewState state) {
    bool openCloseWannaGo = state.openWannagoListPoint;
    bool openCloseCurrentLo = state.openStartingListPoint;
    var searchingObject = state.searchingObject ??
        SearchingObject(type: '', query: [], features: [], attribution: '');
    var _listmarker = state.listMarker;
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                focusNode: forcusNode1,
                controller: _presentLocationController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Your Location',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _viewmodel
                          .getSearchingObject(_presentLocationController.text);
                      _viewmodel.openStarting(true);
                      forcusNode1.unfocus();
                    },
                    icon: const Icon(Icons.search),
                  ),
                ),
                onTap: () {
                  _viewmodel.openWannago(false);
                },
                onChanged: (str) {
                  if (str.isEmpty) {
                    _viewmodel.openStarting(false);
                  }
                },
              ),
              openCloseCurrentLo && searchingObject.type != ''
                  ? Flexible(
                      fit: FlexFit.loose,
                      child: SizedBox(
                        height: 350,
                        child: ListView.builder(
                          itemCount: searchingObject.features.length,
                          itemBuilder: (context, index) {
                            if (searchingObject.features.isEmpty) {
                              return const Text('We cant found this!');
                            } else {
                              var obj = searchingObject.features[index];
                              return ListTile(
                                onTap: () async {
                                  _viewmodel.openStarting(false);
                                  _presentLocationController.text =
                                      searchingObject.features[index].text!;

                                  final GoogleMapController controller =
                                      await _controller.future;
                                  controller.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: LatLng(
                                            obj.center![1], obj.center![0]),
                                        zoom: 16,
                                      ),
                                    ),
                                  );
                                  Logger().e('Chay hay ko');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Pick up your Location'),
                                    ),
                                  );
                                },
                                title: Text(
                                    searchingObject.features[index].text ??
                                        'Unknow'),
                                subtitle: Text(
                                  searchingObject.features[index].placeName ??
                                      'Unknown',
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    )
                  : const SizedBox(),
              TextFormField(
                controller: _wannagoLocationController,
                focusNode: forcusNode2,
                onTap: () {
                  _viewmodel.openStarting(false);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search some where',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _viewmodel.openWannago(true);
                      _viewmodel
                          .getSearchingObject(_wannagoLocationController.text);
                      forcusNode2.unfocus();
                    },
                    icon: const Icon(Icons.search),
                  ),
                ),
                onChanged: (str) {
                  if (str.isEmpty) {
                    _viewmodel.openWannago(false);
                  }
                },
              ),
              openCloseWannaGo
                  ? Flexible(
                      fit: FlexFit.loose,
                      child: SizedBox(
                        height: 350,
                        child: ListView.builder(
                          itemCount: searchingObject.features.length,
                          itemBuilder: (context, index) {
                            var obj = searchingObject.features[index];
                            return ListTile(
                              onTap: () async {
                                _viewmodel.openWannago(false);
                                _wannagoLocationController.text =
                                    searchingObject.features[index].text!;
                                final GoogleMapController controller =
                                    await _controller.future;
                                controller.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(
                                          obj.center![1], obj.center![0]),
                                      zoom: 16,
                                    ),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('pick up your destinations'),
                                ));
                              },
                              title: Text(
                                  searchingObject.features[index].text ??
                                      'Unknow'),
                              subtitle: Text(
                                searchingObject.features[index].placeName ??
                                    'Unknown',
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextButton(
                      onPressed: () async {
                        _viewmodel.openOption(!state.openOption);

                        if (_listmarker.length == 1) {
                          if (_presentLocationController.text.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Pick starting point and destination'),
                              ),
                            );
                          } else {
                            _viewmodel.updateCurrentSpeed(state.currentSpeed);
                            distance =
                                '${state.longtitude},${state.latetitude};${_listmarker[0].position.longitude},${_listmarker[0].position.latitude}';
                            Logger().e(distance);
                            _viewmodel.getDirectionObjDriving(distance);
                          }
                        } else if (_listmarker.length == 2) {
                          print('CO chay vao day ko');
                          Logger().d(state.listMarker.length);
                          distance =
                              '${_listmarker[0].position.longitude},${_listmarker[0].position.latitude};${_listmarker[1].position.longitude},${_listmarker[1].position.latitude}';
                          _viewmodel.getDirectionObjDriving(distance);
                        }
                        location.onLocationChanged.listen((event) {
                          _viewmodel.updateCurrentSpeed(event.speed ?? 40);
                        }, cancelOnError: true);
                      },
                      child: const Text('Find'),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () {
                        _viewmodel.openOption(false);
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
