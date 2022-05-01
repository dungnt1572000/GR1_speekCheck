
import 'package:doan1/src/apicalling/node.dart';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://api.openstreetmap.org/api/0.6/')
abstract class RestClient {
  factory RestClient(Dio dio,{String baseUrl}) = _RestClient;

  @GET('map.json')
  Future<Node> fetchToGetNotes(
      @Header('Authorization') String header, @Query('bbox') String bbox);


  // @GET('notes/{id}/ways.json')

}
