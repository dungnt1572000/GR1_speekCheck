import 'package:doan1/src/searching_service/searching_object.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'api_search_client.g.dart';
@RestApi(baseUrl: 'https://api.mapbox.com/geocoding/v5/')
abstract class SearchingClient{
  factory SearchingClient(Dio dio, {String baseUrl}) = _SearchingClient;

  @GET('mapbox.places/{place}.json')
  Future<SearchingObject> fetchToGetSearchingObject(@Path('place') String place, @Query('access_token') String accesstoken);
}