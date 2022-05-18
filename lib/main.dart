import 'dart:async';

import 'package:doan1/main_viewmodel.dart';
import 'package:doan1/searching/sear_viewmodel.dart';
import 'package:doan1/src/direction_service/direction_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

import 'aleart_screen.dart';

void main() => runApp(const ProviderScope(child: const MyApp()));
List<LatLng> myListLatLng = [];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _presentLocationController =
      TextEditingController();
  final TextEditingController _wannagoLocationController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
    bool UIcheckfindProvider = ref.watch(findOptionProvider);
    bool UIopenInforSceen = ref.watch(openDraggableInforProvider);
    DirectionObject directionsObject = ref.watch(directionsProvider);
    var curSpeed = ref.watch(speedProvider);
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
          controller
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(_locationData.latitude!, _locationData.longitude!),
            zoom: 11.15,
          )));
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
            UIcheckfindProvider
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    onPressed: () {
                      ref
                          .read(findOptionProvider.state)
                          .update((state) => !state);
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blue,
                    ))
                : _buildSearchingBar(),
            directionsObject.uuid.isNotEmpty
                ? DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    maxChildSize: 0.5,
                    minChildSize: 0.05,
                    builder: (context, scrollController) => Container(
                      color: Colors.white,
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Icon(Icons.arrow_upward_outlined),
                          Divider(),
                          Text(
                              'Start point: ${directionsObject.waypoints[0].name}'),
                          Text(
                              'End point: ${directionsObject.waypoints[1].name}'),
                          Text('current Speed: ${curSpeed}'),
                          Text(
                              'Distance: ${directionsObject.routes[0].distance}'),
                          Text(
                              'Time Directions: ${directionsObject.routes[0].duration}')
                        ],
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  _handleTap(LatLng latln) {
    var _listmarker = ref.watch(markerProvider);
    var _late = ref.watch(latetitudeProvider);
    var _long = ref.watch(longtitudeProvider);
    if (_listmarker.length < 2) {
      ref.read(markerProvider.notifier).addMarker(
          Marker(markerId: MarkerId(latln.toString()), position: latln));
      Logger().w(latln.toString());
      myListLatLng.clear();
    } else {
      ref.read(markerProvider.notifier).deleteAllMarker();
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
      padding: const EdgeInsets.only(top: 32),
      color: Colors.white,
      child: Form(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
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
                                target: LatLng(obj.center![1], obj.center![0]),
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
                  var distance = '';
                  ref.read(findOptionProvider.state).update((state) => !state);
                  if (_presentLocationController.text.isEmpty) {
                    if (_listmarker.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Pick starting point and destination')));
                  }
                  if (_listmarker.length == 1) {
                    if (_presentLocationController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
                          .getDirectionObj(distance);
                    }
                  }
                  if (_listmarker.length == 2) {
                    distance =
                        '${_listmarker[0].position.longitude},${_listmarker[0].position.latitude};${_listmarker[1].position.longitude},${_listmarker[1].position.latitude}';
                    ref
                        .read(directionsProvider.notifier)
                        .getDirectionObj(distance);
                  }
                },
                child: const Text('Find'))
          ],
        ),
      )),
    );
  }
}
