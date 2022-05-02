import 'package:dio/dio.dart';
import 'package:doan1/src/apicalling/api_client.dart';
import 'package:doan1/src/apicalling/node.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

final latetitudeProvider = StateProvider(
  (ref) =>10.762622,
);

final longtitudeProvider = StateProvider(
  (ref) => 106.660172,
);
final speedProvider = StateProvider(
  (ref) => 0.0,
);
final openCloseMenuProvider = StateProvider(
  (ref) => true,
);
final zoomProvider = StateProvider((ref) => 13,);
class NodeStateNotifier extends StateNotifier<Node> {
  NodeStateNotifier(state) : super(state);

  void getNote(String coordinate) async {
    state = await RestClient(Dio()).fetchToGetNotes(
        'Basic ZHVuZ3BybzE1NzJrQGdtYWlsLmNvbTpuZ3V5ZW50YW5kdW5ncHJvMTU3MjAwMA==',
        coordinate);
    //long + 0.00011
    // late + 0.005
    Logger().e(state.elements.length);
    Logger().d(coordinate);

    // for(int i=0 ; i< state.elements.length ; i++){
    //   print(state.elements[i].runtimeType);
    // }
  }
}

final noteProvider = StateNotifierProvider<NodeStateNotifier, Node>(
  (ref) => NodeStateNotifier(Node(
      attribution: '',
      copyright: '',
      generator: '',
      license: '',
      version: '',
      bounds: Bounds(minlat: 0.0, minlon: 0.0, maxlat: 0.0, maxlon: 0.0),
      elements: [])),
);

final markerNodeProvider = Provider<List<MapNode>>(
  (ref) {
    var listAll = ref.watch(noteProvider);
    var myList = listAll.elements.whereType<MapNode>().toList();
    return myList;
  },
);

final markerWayProvider = Provider<List<MapWay>>(
  (ref) {
    var listAll = ref.watch(noteProvider);
    var myList = listAll.elements.whereType<MapWay>().toList();
    return myList;
  },
);

class MarkerNotifier extends StateNotifier<Set<Marker>>{
  MarkerNotifier([Set<Marker>? state]) : super(state??{});
  void addMarker(Marker marker){
    state ={...state,marker};
  }
}
final markerProvider = StateNotifierProvider<MarkerNotifier,Set<Marker>>((ref) {
  return MarkerNotifier({});
},);


