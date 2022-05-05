// To parse this JSON data, do
//
//     final searchingObject = searchingObjectFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SearchingObject searchingObjectFromJson(String str) => SearchingObject.fromJson(json.decode(str));

// String searchingObjectToJson(SearchingObject data) => json.encode(data.toJson());

class SearchingObject {
  SearchingObject({
    required this.type,
    required this.query,
    required this.features,
    required this.attribution,
  });

  String type;
  List<String> query;
  List<Feature> features;
  String attribution;

  factory SearchingObject.fromJson(Map<String, dynamic> json) => SearchingObject(
    type: json["type"],
    query: List<String>.from(json["query"].map((x) => x)),
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
    attribution: json["attribution"],
  );


}

class Feature {
  Feature({
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

  String? id;
  String? type;
  List<String>? placeType;
  int? relevance;
  Properties? properties;
  String? text;
  String? placeName;
  List<double>? bbox;
  List<double>? center;
  Geometry? geometry;
  List<Context>? context;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    id: json["id"],
    type: json["type"],
    placeType: List<String>.from(json["place_type"].map((x) => x)),
    relevance: json["relevance"],
    properties: Properties.fromJson(json["properties"]),
    text: json["text"],
    placeName: json["place_name"],
    bbox: json['bbox']==null?[]:List.castFrom(json['bbox']),
    center: List<double>.from(json["center"].map((x) => x.toDouble())),
    geometry: Geometry.fromJson(json["geometry"]),
    context: List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
  );


}

class Context {
  Context({
    required this.id,
    required this.wikidata,
    required this.text,
    required this.shortCode,
  });

  String? id;
  String? wikidata;
  String? text;
  String? shortCode;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
    id: json["id"],
    wikidata: json["wikidata"] == null ? null : json["wikidata"],
    text: json["text"],
    shortCode: json["short_code"] == null ? null : json["short_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "wikidata": wikidata == null ? null : wikidata,
    "text": text,
    "short_code": shortCode == null ? null : shortCode,
  };
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  String? type;
  List<double>? coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: json["type"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );


}

class Properties {
  Properties({
    required this.wikidata,
    required this.foursquare,
    required this.landmark,
    required this.address,
    required this.category,
    required this.maki,
  });

  String? wikidata;
  String? foursquare;
  bool? landmark;
  String? address;
  String? category;
  String? maki;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    wikidata: json["wikidata"] == null ? null : json["wikidata"],
    foursquare: json["foursquare"] == null ? null : json["foursquare"],
    landmark: json["landmark"] == null ? null : json["landmark"],
    address: json["address"] == null ? null : json["address"],
    category: json["category"] == null ? null : json["category"],
    maki: json["maki"] == null ? null : json["maki"],
  );

  Map<String, dynamic> toJson() => {
    "wikidata": wikidata == null ? null : wikidata,
    "foursquare": foursquare == null ? null : foursquare,
    "landmark": landmark == null ? null : landmark,
    "address": address == null ? null : address,
    "category": category == null ? null : category,
    "maki": maki == null ? null : maki,
  };
}
