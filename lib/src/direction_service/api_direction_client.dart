import 'package:dio/dio.dart';
import 'package:doan1/src/direction_service/direction_object.dart';
import 'package:retrofit/http.dart';

part 'api_direction_client.g.dart';

@RestApi(baseUrl: 'https://api.mapbox.com/directions/v5/mapbox/')
abstract class DirectionsClient {
  factory DirectionsClient(Dio dio, {String baseUrl}) = _DirectionsClient;

  @GET('driving/{direction}')
  Future<DirectionObject> getDirectionDriving(
      @Path('direction') String direction,
      @Query('access_token') String accessToken,
      @Query('annotations') String annotations,
      @Query('geometries') String geometries,
      @Query('overview') String overviews);
  @GET('walking/{direction}')
  Future<DirectionObject> getDirectionWalking(
      @Path('direction') String direction,
      @Query('access_token') String accessToken,
      @Query('annotations') String annotations,
      @Query('geometries') String geometries,
      @Query('overview') String overviews);

}
