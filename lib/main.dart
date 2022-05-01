import 'dart:async';

import 'package:doan1/main_viewmodel.dart';
import 'package:doan1/maintest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    bool openClose = ref.watch(openCloseMenuProvider);
    double latitude = ref.watch(latetitudeProvider);
    double longtitude = ref.watch(longtitudeProvider);
    var mapNote = ref.watch(noteProvider);
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
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
          location.onLocationChanged.listen((LocationData currentLocation) {
            // Use current location
            ref.read(latetitudeProvider.state).update((state) => state = currentLocation.latitude??21.0245);
            ref.read(longtitudeProvider.state).update((state) => state = currentLocation.longitude??105.84117);

          });
        },
        child: Icon(Icons.my_location),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude,longtitude),
              zoom: 11.5
            ),
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
          )
        ],
      ),
    );
  }
  

}
