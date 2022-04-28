import 'package:doan1/main_viewmodel.dart';
import 'package:doan1/src/apicalling/map_notes.dart';
import 'package:doan1/src/apicalling/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

void main() {
  int a = 3;
  print(a is int);
  // runApp(const ProviderScope(
  //     child: MaterialApp(
  //   home: MyApp(),
  // )));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    double latitude = ref.watch(latetitudeProvider);
    double longtitude = ref.watch(longtitudeProvider);
    double curspeed = ref.watch(speedProvider);
    var mapNotes = ref.watch(noteProvider);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            color: Colors.amber,
            child: Row(
              children: [
                const Expanded(child: Text('Hi there, where u going')),
                Expanded(
                    child: TextFormField(
                  onTap: () async {
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
                    ref.read(noteProvider.notifier).getNote();
                    _locationData = await location.getLocation();
                    ref
                        .read(latetitudeProvider.state)
                        .update((state) => _locationData.latitude!);
                    ref
                        .read(longtitudeProvider.state)
                        .update((state) => _locationData.longitude!);
                    ref
                        .read(speedProvider.state)
                        .update((state) => _locationData.speed!);
                  },
                  decoration: InputDecoration(hintText: '$curspeed'),
                ))
              ],
            ),
          ),
          Expanded(
            child: Stack(children: [
              FlutterMap(
                options: MapOptions(
                  center: LatLng(latitude, longtitude),
                  zoom: 14,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    attributionBuilder: (_) {
                      return Text("© OpenStreetMap contributors");
                    },
                  ),
                  //   MarkerLayerOptions(
                  //     markers: mapNotes.elements.map((e) {
                  //       if (e.lat != null) {
                  //         return Marker(
                  //             point: LatLng(e.lat!, e.lon!),
                  //             builder: (ctx) => IconButton(
                  //                 onPressed: () {
                  //                   showDialog(
                  //                       context: context,
                  //                       builder: (BuildContext context) {
                  //                         return AlertDialog(
                  //                           title: Text("Location: " +
                  //                               e.lat.toString() +
                  //                               '-' +
                  //                               e.lon.toString()),
                  //                           content: Text('Ten cua no'),
                  //                         );
                  //                       });
                  //                 },
                  //                 icon: Icon(Icons.place)));
                  //       }
                  //       return Marker(
                  //         width: 80.0,
                  //         height: 80.0,
                  //         point: LatLng(e.lat ?? 45.0, e.lon ?? 45.0),
                  //         builder: (ctx) => const SizedBox(),
                  //       );
                  //     }).toList()
                  //     // [
                  //     // Marker(
                  //     //   width: 80.0,
                  //     //   height: 80.0,
                  //     //   point: LatLng(latitude, longtitude),
                  //     //   builder: (ctx) => Container(
                  //     //     child: Icon(Icons.place),
                  //     //   ),
                  //     // ),
                  //     // ]

                  //     ,
                  //   ),
                ],
              ),
              Positioned(
                  child: Card(
                child: Container(
                    child: Column(
                  children: [
                    Text('Some Street you near'),
                    ListView.builder(
                      itemCount: mapNotes.elements
                          .where((element) => element is MapWay)
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        var listforStreet = mapNotes.elements
                            .where(
                              (element) => element is MapWay,
                            )
                            .toList();
                        return ListTile(
                          title: Text('HAHA'),
                        );
                      },
                    )
                  ],
                )),
              ))
            ]),
          )
        ],
      )),
    );
  }
}
