// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_direction_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _DirectionsClient implements DirectionsClient {
  _DirectionsClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.mapbox.com/directions/v5/mapbox/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<DirectionObject> getDirection(
      direction, accessToken, annotations, geometries, overviews) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'access_token': accessToken,
      r'annotations': annotations,
      r'geometries': geometries,
      r'overview': overviews
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DirectionObject>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'driving/${direction}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DirectionObject.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
