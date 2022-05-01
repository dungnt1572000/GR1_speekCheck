import 'package:dio/dio.dart';
import 'package:doan1/src/apicalling/api_client.dart';
import 'package:doan1/src/apicalling/node.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final latetitudeProvider = StateProvider(
  (ref) => 21.0245,
);

final longtitudeProvider = StateProvider(
  (ref) => 105.84117,
);
final speedProvider = StateProvider(
  (ref) => 0.0,
);
final openCloseMenuProvider = StateProvider(
  (ref) => true,
);

class NodeStateNotifier extends StateNotifier<Node> {
  NodeStateNotifier(state) : super(state);

  void getNote() async {
    state = await RestClient(Dio()).fetchToGetNotes(
        'Basic ZHVuZ3BybzE1NzJrQGdtYWlsLmNvbTpuZ3V5ZW50YW5kdW5ncHJvMTU3MjAwMA==',
        '105.7703402,21.003471,105.7704502,21.008471');
    // print(state.elements.length);
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
