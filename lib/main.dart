import 'dart:async';

import 'package:doan1/main_viewmodel.dart';
import 'package:doan1/searching/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(const ProviderScope(child: const MyApp()));

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
    bool openClose = ref.watch(openCloseMenuProvider);
    double latitude = ref.watch(latetitudeProvider);
    double longtitude = ref.watch(longtitudeProvider);
    var mapNote = ref.watch(noteProvider);
    var mapListNode = ref.watch(markerNodeProvider);
    var mapListWay = ref.watch(markerWayProvider);
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    Set<Marker> _marker = ref.watch(markerProvider);

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
          print(_locationData.latitude);

          print(_locationData.longitude);

          ref
              .read(latetitudeProvider.state)
              .update((state) => state = _locationData.latitude ?? 21.0245);
          ref
              .read(longtitudeProvider.state)
              .update((state) => state = _locationData.longitude ?? 105.84117);
          print(latitude);

          print(longtitude);

          final GoogleMapController controller = await _controller.future;
          controller
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(_locationData.latitude!, _locationData.longitude!),
            zoom: 11.15,
          )));
          // _marker.add();
          // for (final marker in mapListNode) {
          //   _marker.add(Marker(
          //       markerId: MarkerId(marker.id.toString()),
          //       position: LatLng(marker.lat, marker.lon),
          //       icon: ,
          //       infoWindow: InfoWindow(title: 'added by ${marker.user}')));
          // }

          ref.read(markerProvider).add(Marker(
              markerId: const MarkerId('currentId'),
              infoWindow: const InfoWindow(title: 'current location',),
              
              position:
                  LatLng(_locationData.latitude!, _locationData.longitude!),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose)));
        },
        child: const Icon(Icons.my_location),
      ),
      body: Stack(
        children: [

              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longtitude), zoom: 11.5),
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                markers: _marker,
                onMapCreated: (GoogleMapController controller) {
                  return _controller.complete(controller);
                },
              ),
          Container(
              padding: EdgeInsets.only(top: 32),
              color: Colors.white,
              child: const SearchingBar()),
        ],
      ),
    );
  }
}
