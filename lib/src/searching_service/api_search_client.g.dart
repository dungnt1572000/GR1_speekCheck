// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_search_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _SearchingClient implements SearchingClient {
  _SearchingClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.mapbox.com/geocoding/v5/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<SearchingObject> fetchToGetSearchingObject(place, accesstoken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'access_token': accesstoken};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SearchingObject>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'mapbox.places/${place}.json',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SearchingObject.fromJson(_result.data!);
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
