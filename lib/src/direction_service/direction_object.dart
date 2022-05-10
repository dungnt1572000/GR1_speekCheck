import 'dart:convert';

DirectionObject directionObjectFromJson(String str) => DirectionObject.fromJson(json.decode(str));


class DirectionObject {
  DirectionObject({
    required this.routes,
    required this.waypoints,
    required this.code,
    required this.uuid,
  });

  final List<Route> routes;
  final List<Waypoint> waypoints;
  final String code;
  final String uuid;

  factory DirectionObject.fromJson(Map<String, dynamic> json) => DirectionObject(
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
    waypoints: List<Waypoint>.from(json["waypoints"].map((x) => Waypoint.fromJson(x))),
    code: json["code"],
    uuid: json["uuid"],
  );

}

class Route {
  Route({
    required this.countryCrossed,
    required this.weightName,
    required this.weight,
    required this.duration,
    required this.distance,
    required this.legs,
    required this.geometry,
  });

  final bool countryCrossed;
  final String weightName;
  final double weight;
  final double duration;
  final double distance;
  final List<Leg> legs;
  final Geometry geometry;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    countryCrossed: json["country_crossed"],
    weightName: json["weight_name"],
    weight: json["weight"].toDouble(),
    duration: json["duration"].toDouble(),
    distance: json["distance"].toDouble(),
    legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
    geometry: Geometry.fromJson(json["geometry"]),
  );

}

class Geometry {
  Geometry({
    required this.coordinates,
    required this.type,
  });

  final List<List<double>> coordinates;
  final String type;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    coordinates: List<List<double>>.from(json["coordinates"].map((x) => List<double>.from(x.map((x) => x.toDouble())))),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "type": type,
  };
}

class Leg {
  Leg({
    required this.viaWaypoints,
    required this.annotation,
    required this.admins,
    required this.weight,
    required this.duration,
    required this.steps,
    required this.distance,
    required this.summary,
  });

  final List<dynamic> viaWaypoints;
  final Annotation annotation;
  final List<Admin> admins;
  final double weight;
  final double duration;
  final List<dynamic> steps;
  final double distance;
  final String summary;

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    viaWaypoints: List<dynamic>.from(json["via_waypoints"].map((x) => x)),
    annotation: Annotation.fromJson(json["annotation"]),
    admins: List<Admin>.from(json["admins"].map((x) => Admin.fromJson(x))),
    weight: json["weight"].toDouble(),
    duration: json["duration"].toDouble(),
    steps: List<dynamic>.from(json["steps"].map((x) => x)),
    distance: json["distance"].toDouble(),
    summary: json["summary"],
  );


}

class Admin {
  Admin({
    required this.iso31661Alpha3,
    required this.iso31661,
  });

  final String iso31661Alpha3;
  final String iso31661;

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    iso31661Alpha3: json["iso_3166_1_alpha3"],
    iso31661: json["iso_3166_1"],
  );

  Map<String, dynamic> toJson() => {
    "iso_3166_1_alpha3": iso31661Alpha3,
    "iso_3166_1": iso31661,
  };
}

class Annotation {
  Annotation({
    required this.maxspeed,
  });

  final List<Maxspeed> maxspeed;

  factory Annotation.fromJson(Map<String, dynamic> json) => Annotation(
    maxspeed: List<Maxspeed>.from(json["maxspeed"].map((x) => Maxspeed.fromJson(x))),
  );


}

class Maxspeed {
  Maxspeed({
    required this.unknown,
    required this.speed,
    required this.unit,
  });

  final bool? unknown;
  final int? speed;
  final String? unit;

  factory Maxspeed.fromJson(Map<String, dynamic> json) => Maxspeed(
    unknown: json["unknown"] == null ? null : json["unknown"],
    speed: json["speed"] == null ? null : json["speed"],
    unit: json["unit"] == null ? null : json['unit'],
  );


}


class Waypoint {
  Waypoint({
    required this.distance,
    required this.name,
    required this.location,
  });

  final double distance;
  final String name;
  final List<double> location;

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
    distance: json["distance"].toDouble(),
    name: json["name"],
    location: List<double>.from(json["location"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "distance": distance,
    "name": name,
    "location": List<dynamic>.from(location.map((x) => x)),
  };
}

