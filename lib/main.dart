import 'dart:async';
import 'package:doan1/main_viewmodel.dart';
import 'package:doan1/searching/sear_viewmodel.dart';
import 'package:doan1/splash_screen.dart';
import 'package:doan1/src/direction_service/direction_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

void main() => runApp(const ProviderScope(child: MyApp()));
List<LatLng> myListLatLng = [];

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
  var distance = '';
  FocusNode forcusNode1 = FocusNode();
  FocusNode forcusNode2 = FocusNode();
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _presentLocationController =
  TextEditingController();
  final TextEditingController _wannagoLocationController =
  TextEditingController();

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


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    forcusNode1.dispose();
    forcusNode2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double latitude = ref.watch(latetitudeProvider);
    double longtitude = ref.watch(longtitudeProvider);
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    List<Marker> _marker = ref.watch(markerProvider);
    bool uIcheckfindProvider = ref.watch(findOptionProvider);
    bool openInfor = ref.watch(openInformationProvider);
    String typeGoing = ref.watch(typeGoingProvider);
    DirectionObject directionsObject = ref.watch(directionsProvider);
    var curSpeed = ref.watch(speedProvider);
    int? _getCurrentSpeed() {
      int sml = 0;
      var arrSpeed = directionsObject.routes[0].legs[0].annotation.maxspeed;
      for (int i = 0; i < arrSpeed.length; i++) {
        if (arrSpeed[i].unknown == true) {
          arrSpeed.insert(i, Maxspeed(speed: 40, unit: 'km/h', unknown: null));
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
                (element) =>
            latitude >= element[1] && longtitude <= element[0]);
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
                (element) =>
            latitude >= element[1] && longtitude >= element[0]);
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

          ref
              .read(latetitudeProvider.state)
              .update((state) => state = _locationData.latitude ?? 21.0245);
          ref
              .read(longtitudeProvider.state)
              .update((state) => state = _locationData.longitude ?? 105.84117);

          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target:
                LatLng(_locationData.latitude!, _locationData.longitude!),
                zoom: 11.15,
              ),
            ),
          );
          location.onLocationChanged.listen((event) {
            ref
                .read(speedProvider.notifier)
                .update((state) => event.speed ?? 0);
            event.heading != 1.1;
          });
        },
        child: const Icon(Icons.my_location),
      ),
      body: SafeArea(
        child: Stack(
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
                    color: Colors.red,
                    width: 3,
                    polylineId: const PolylineId('halo'),
                    points: myListLatLng)
              },
            ),
            AnimatedCrossFade(
                firstChild: _buildSearchingBar(),
                secondChild: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    onPressed: () {
                      ref
                          .read(findOptionProvider.state)
                          .update((state) => !state);
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blue,
                    )),
                crossFadeState: uIcheckfindProvider
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 500)),
            if (openInfor == true && myListLatLng.isNotEmpty)
              DraggableScrollableSheet(
                initialChildSize: 0.4,
                maxChildSize: 0.5,
                minChildSize: 0.03,
                builder: (context, scrollController) =>
                    Container(
                      color: Colors.white,
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                  child: TextButton(
                                    child: const Icon(
                                        Icons.directions_run_rounded),
                                    onPressed: () {
                                      ref
                                          .read(typeGoingProvider.notifier)
                                          .update((state) => 'Run');
                                      ref
                                          .read(directionsProvider.notifier)
                                          .getDirectionObjWalking(distance);
                                    },
                                  )),
                              Expanded(
                                  child: TextButton(
                                      child:
                                      const Icon(Icons.directions_car_rounded),
                                      onPressed: () {
                                        ref
                                            .read(typeGoingProvider.notifier)
                                            .update((state) => 'Car/Motorbike');
                                        ref
                                            .read(directionsProvider.notifier)
                                            .getDirectionObjDriving(distance);
                                      })),
                              Expanded(
                                  child: TextButton(
                                      child:
                                      const Icon(Icons.directions_bike_rounded),
                                      onPressed: () {})),
                            ],
                          ),
                          const Divider(
                            height: 2,
                            color: Colors.red,
                          ),
                          Text(
                            'Kind of Driving: $typeGoing',
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 28,
                                fontWeight: FontWeight.normal),
                          ),
                          const Divider(),
                          Text(
                            'Current Speed: ${curSpeed.toStringAsFixed(
                                2)} km/h',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Divider(),
                          Text(
                            'Starting point: ${directionsObject.waypoints[0]
                                .name}',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 20),
                          ),
                          Text('Ends point: ${directionsObject.waypoints[1]
                              .name}',
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 20)),
                          Text(
                              'Duration: ${directionsObject.routes[0]
                                  .duration} sec',
                              style: const TextStyle(
                                  color: Colors.amber, fontSize: 20)),
                          Text(
                              'Distance : ${directionsObject.routes[0]
                                  .distance} m',
                              style: const TextStyle(
                                  color: Colors.orange, fontSize: 20)),
                          Text(
                              'Abroad: ${directionsObject.routes[0]
                                  .countryCrossed}',
                              style:
                              const TextStyle(color: Colors.red, fontSize: 17)),
                          const Divider(height: 12),
                          Text(
                              'Accept Current Speed in this Way: ${_getCurrentSpeed() ??
                                  40}km/h',
                              style:
                              const TextStyle(color: Colors.red, fontSize: 20))
                        ],
                      ),
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
    var _listmarker = ref.watch(markerProvider);
    if (_listmarker.length < 2) {
      ref.read(markerProvider.notifier).addMarker(
          Marker(markerId: MarkerId(latln.toString()), position: latln));
      Logger().w(latln.toString());
    } else {
      ref.read(markerProvider.notifier).deleteAllMarker();
      ref.read(openInformationProvider.state).update((state) => false);
      setState(() {
        myListLatLng.clear();
      });
    }
  }

  Widget _buildSearchingBar() {
    bool openCloseWannaGo = ref.watch(openCloseupListWannaGoProvider);
    bool openCloseCurrentLo = ref.watch(openCloseupListCurrentStartProvider);
    var searchingObject = ref.watch(SearchingObjectProvider);
    var _listmarker = ref.watch(markerProvider);
    var _late = ref.watch(latetitudeProvider);
    var _long = ref.watch(longtitudeProvider);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      color: Colors.white,
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
                            ref
                                .read(SearchingObjectProvider.notifier)
                                .getSearchingObject(
                                _presentLocationController.text);
                            ref
                                .read(openCloseupListCurrentStartProvider.state)
                                .update((state) => true);
                            forcusNode1.unfocus();
                          },
                          icon: const Icon(Icons.search))),
                  onTap: () {
                    ref
                        .read(openCloseupListWannaGoProvider.state)
                        .update((state) => false);
                  },
                  onChanged: (str) {
                    if (str.isEmpty) {
                      ref
                          .read(openCloseupListCurrentStartProvider.state)
                          .update((state) => false);
                    }
                  },
                ),
                openCloseCurrentLo
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
                              ref
                                  .read(openCloseupListCurrentStartProvider
                                  .state)
                                  .update((state) => false);
                              _presentLocationController.text =
                              searchingObject.features[index].text!;

                              final GoogleMapController controller =
                              await _controller.future;
                              controller.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target:
                                        LatLng(obj.center![1], obj.center![0]),
                                        zoom: 16,
                                      )));
                              Logger().e('Chay hay ko');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                      Text('Pick up your Location')));
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
                    ref
                        .read(openCloseupListCurrentStartProvider.state)
                        .update((state) => false);
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search some where',
                      suffixIcon: IconButton(
                          onPressed: () {
                            ref
                                .read(openCloseupListWannaGoProvider.state)
                                .update((state) => true);
                            ref
                                .read(SearchingObjectProvider.notifier)
                                .getSearchingObject(
                                _wannagoLocationController.text);
                            forcusNode2.unfocus();
                          },
                          icon: const Icon(Icons.search))),
                  onChanged: (str) {
                    if (str.isEmpty) {
                      ref
                          .read(openCloseupListWannaGoProvider.state)
                          .update((state) => false);
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
                            ref
                                .read(openCloseupListWannaGoProvider.state)
                                .update((state) => false);
                            _wannagoLocationController.text =
                            searchingObject.features[index].text!;
                            final GoogleMapController controller =
                            await _controller.future;
                            controller.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(
                                      obj.center![1], obj.center![0]),
                                  zoom: 16,
                                )));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text('pick up your destinations')));
                          },
                          title: Text(searchingObject.features[index].text ??
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
                TextButton(
                    onPressed: () {
                      ref.read(findOptionProvider.state).update((
                          state) => !state);
                      if (_presentLocationController.text.isEmpty) {
                        if (_listmarker.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text('Pick starting point and destination')));
                        }
                        if (_listmarker.length == 1) {
                          _listmarker.insert(
                              0,
                              Marker(
                                  markerId: const MarkerId('current point'),
                                  position: LatLng(_late, _long)));
                        }
                      }
                      if (_listmarker.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Pick starting point and destination')));
                      }
                      if (_listmarker.length == 1) {
                        if (_presentLocationController.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text('Pick starting point and destination')));
                        } else {
                          _listmarker.insert(
                              0,
                              Marker(
                                  markerId: const MarkerId('current point'),
                                  position: LatLng(_late, _long)));
                          ref
                              .read(directionsProvider.notifier)
                              .getDirectionObjDriving(distance);
                        }
                      }
                      if (_listmarker.length == 2) {
                        distance =
                        '${_listmarker[0].position.longitude},${_listmarker[0]
                            .position.latitude};${_listmarker[1].position
                            .longitude},${_listmarker[1].position.latitude}';
                        ref
                            .read(directionsProvider.notifier)
                            .getDirectionObjDriving(distance);
                        ref
                            .read(openInformationProvider.state)
                            .update((state) => true);
                      }
                    },
                    child: const Text('Find'))
              ],
            ),
          )),
    );
  }
}
