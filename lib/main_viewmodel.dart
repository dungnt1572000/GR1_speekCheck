import 'package:doan1/src/apicalling/api_client.dart';
import 'package:doan1/src/apicalling/map_notes.dart';
import 'package:doan1/src/apicalling/node.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final latetitudeProvider = StateProvider(
  (ref) => 32.12,
);

final longtitudeProvider = StateProvider(
  (ref) => 32.43,
);
final speedProvider = StateProvider(
  (ref) => 0.0,
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
