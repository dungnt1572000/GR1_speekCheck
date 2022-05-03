import 'package:freezed_annotation/freezed_annotation.dart';

class SearchingObject{
  late final String type;
  late final List<String> query;
  late final List<dynamic> features;
  late final String attribution;

  SearchingObject(this.type, this.query, this.features, this.attribution);
  SearchingObject.fromJson(Map<String,dynamic> json){
    type = json['type'];
    query = List.castFrom(json['query']);
    features = List<Map<String,dynamic>>.from(json['features']).map((e){
      if(e.entries.toList()[0].key.contains('place')){
        return PlaceObject.fromJson(e);
      }
      if(e.entries.toList()[0].key.contains('poi')){
        return PositionObject.fromJson(e);
      }
    }).toList();
  }
}
class PositionObject{
  late final String id;
  late final String type;
  late final List<String> placeType;
  late final double relevance;
  late final PosiProperties posiproperties;
  late final String text;
  late final String placeName;
  late final List<double> center;
  late final Geometry geometry;
  late final List<Context> context;

  PositionObject(this.id, this.type, this.placeType, this.relevance,
      this.posiproperties, this.text, this.placeName, this.center, this.geometry,
      this.context);
  PositionObject.fromJson(Map<String, dynamic> json){
    id = json['id'];
    type = json['type'];
    placeType = List.castFrom<dynamic, String>(json['place_type']);
    relevance = json['relevance'];
    posiproperties = PosiProperties.fromJson(json['properties']);
    text = json['text'];
    placeName = json['place_name'];
    center = List.castFrom<dynamic, double>(json['center']);
    geometry = Geometry.fromJson(json['geometry']);
    context = List.from(json['context']).map((e)=>Context.fromJson(e)).toList();
  }
}
class PosiProperties {
  PosiProperties({
    required this.foursquare,
    required this.landmark,
    required this.address,
    required this.category,
  });
  late final String foursquare;
  late final bool landmark;
  late final String address;
  late final String category;

  PosiProperties.fromJson(Map<String, dynamic> json){
    foursquare = json['foursquare'];
    landmark = json['landmark'];
    address = json['address'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['foursquare'] = foursquare;
    _data['landmark'] = landmark;
    _data['address'] = address;
    _data['category'] = category;
    return _data;
  }
}
class PlaceObject {
  PlaceObject({
    required this.id,
    required this.type,
    required this.placeType,
    required this.relevance,
    required this.properties,
    required this.text,
    required this.placeName,
    required this.bbox,
    required this.center,
    required this.geometry,
    required this.context,
  });
  late final String id;
  late final String type;
  late final List<String> placeType;
  late final int relevance;
  late final Properties properties;
  late final String text;
  late final String placeName;
  late final List<double> bbox;
  late final List<num> center;
  late final Geometry geometry;
  late final List<Context> context;

  PlaceObject.fromJson(Map<String, dynamic> json){
    id = json['id'];
    type = json['type'];
    placeType = List.castFrom<dynamic, String>(json['place_type']);
    relevance = json['relevance'];
    properties = Properties.fromJson(json['properties']);
    text = json['text'];
    placeName = json['place_name'];
    bbox = List.castFrom<dynamic, double>(json['bbox']);
    center = List.castFrom<dynamic, num>(json['center']);
    geometry = Geometry.fromJson(json['geometry']);
    context = List.from(json['context']).map((e)=>Context.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['type'] = type;
    _data['place_type'] = placeType;
    _data['relevance'] = relevance;
    _data['properties'] = properties.toJson();
    _data['text'] = text;
    _data['place_name'] = placeName;
    _data['bbox'] = bbox;
    _data['center'] = center;
    _data['geometry'] = geometry.toJson();
    _data['context'] = context.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Properties {
  Properties({
    required this.shortCode,
    required this.wikidata,
  });
  late final String shortCode;
  late final String wikidata;

  Properties.fromJson(Map<String, dynamic> json){
    shortCode = json['short_code'];
    wikidata = json['wikidata'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['short_code'] = shortCode;
    _data['wikidata'] = wikidata;
    return _data;
  }
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });
  late final String type;
  late final List<num> coordinates;

  Geometry.fromJson(Map<String, dynamic> json){
    type = json['type'];
    coordinates = List.castFrom<dynamic, num>(json['coordinates']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['coordinates'] = coordinates;
    return _data;
  }
}

class Context {
  Context({
    required this.id,
    required this.wikidata,
    required this.shortCode,
    required this.text,
  });
  late final String? id;
  late final String? wikidata;
  late final String? shortCode;
  late final String? text;

  Context.fromJson(Map<String, dynamic> json){
    id = json['id'];
    wikidata = json['wikidata'];
    shortCode = json['short_code'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['wikidata'] = wikidata;
    _data['short_code'] = shortCode;
    _data['text'] = text;
    return _data;
  }
}