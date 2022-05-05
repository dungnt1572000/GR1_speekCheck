import 'package:dio/dio.dart';
import 'package:doan1/constant/accessTokenTest.dart';
import 'package:doan1/src/searching_service/api_search_client.dart';
import 'package:doan1/src/searching_service/searching_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final openCloseupListProvider = StateProvider(
  (ref) => false,
);

class SearchingNotifier extends StateNotifier<SearchingObject> {
  SearchingNotifier() : super(SearchingObject(type: '', query: [], attribution: '', features: []));

  void getSearchingObject(String location) async {
    SearchingClient(Dio())
        .fetchToGetSearchingObject(location, accessToken)
        .then((value) => state = value);
  }
}

final SearchingObjectProvider =
    StateNotifierProvider<SearchingNotifier, SearchingObject>(
  (ref) => SearchingNotifier(),
);
