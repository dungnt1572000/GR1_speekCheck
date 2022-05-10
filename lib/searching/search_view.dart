import 'dart:async';

import 'package:doan1/searching/sear_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

import '../main_viewmodel.dart';

class SearchingBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    TextEditingController _presentLocationController = TextEditingController();
    TextEditingController _wannagoLocationController = TextEditingController();
    _presentLocationController.text = 'Your Location';
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        bool openCloseWannaGo = ref.watch(openCloseupListWannaGoProvider);
        bool openCloseCurrentLo =
            ref.watch(openCloseupListCurrentStartProvider);
        var searchingObject = ref.watch(SearchingObjectProvider);
        return Form(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _presentLocationController,
                decoration: InputDecoration(
                    border: InputBorder.none,
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
                onChanged: (str){
                  if(str.isEmpty){
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
                            }
                            else {
                              var obj = searchingObject.features[index];
                              return ListTile(
                                onTap: () async {
                                  ref
                                      .read(openCloseupListCurrentStartProvider
                                      .state)
                                      .update((state) => false);
                                  _presentLocationController.text =
                                  searchingObject.features[index].text!;
                                  ref
                                      .read(markerProvider.notifier)
                                      .addMarker(
                                      Marker(
                                          icon:
                                          BitmapDescriptor
                                              .defaultMarkerWithHue(
                                              BitmapDescriptor
                                                  .hueRose),
                                          markerId: MarkerId(searchingObject
                                              .features[index].id ??
                                              'none'),
                                          position: LatLng(
                                              searchingObject
                                                  .features[index].center![0],
                                              searchingObject.features[index]
                                                  .center![1])));

                                  Logger().e('Chay hay ko');
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
                onTap: () async {
                  final GoogleMapController controller = await Completer().future;
                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                          const CameraPosition(target: LatLng(112.3,32.4),zoom: 14.4746)));
                  ref
                      .read(openCloseupListCurrentStartProvider.state)
                      .update((state) => false);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search some where',
                    suffixIcon: IconButton(
                        onPressed: () {
                          print('Hello word');
                          ref
                              .read(openCloseupListWannaGoProvider.state)
                              .update((state) => true);
                          ref
                              .read(SearchingObjectProvider.notifier)
                              .getSearchingObject(
                                  _wannagoLocationController.text);
                        },
                        icon: const Icon(Icons.search))),
                onChanged: (str){
                  if(str.isEmpty){
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
                            return ListTile(
                              onTap: () async {
                                ref
                                    .read(openCloseupListWannaGoProvider.state)
                                    .update((state) => false);
                                _wannagoLocationController.text =
                                    searchingObject.features[index].text!;
                                ref
                                    .read(markerProvider.notifier)
                                    .addMarker(
                                        Marker(
                                            icon:
                                                BitmapDescriptor
                                                    .defaultMarkerWithHue(
                                                        BitmapDescriptor
                                                            .hueRose),
                                            markerId: MarkerId(searchingObject
                                                    .features[index].id ??
                                                'none'),
                                            position: LatLng(
                                                searchingObject
                                                    .features[index].center![0],
                                                searchingObject.features[index]
                                                    .center![1])));
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
            ],
          ),
        ));
      },
    );
  }
}

