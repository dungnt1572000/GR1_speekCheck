class Node {
  Node({
    required this.version,
    required this.generator,
    required this.copyright,
    required this.attribution,
    required this.license,
    required this.bounds,
    required this.elements,
  });
  late final String version;
  late final String generator;
  late final String copyright;
  late final String attribution;
  late final String license;
  late final Bounds bounds;
  late final List<dynamic> elements;

  Node.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    generator = json['generator'];
    copyright = json['copyright'];
    attribution = json['attribution'];
    license = json['license'];
    bounds = Bounds.fromJson(json['bounds']);
    elements = List<Map<String, dynamic>>.from(json['elements']).map((e) {
      print(e.entries.toList()[2]);
      if (e.entries.toList()[2].key == 'lat') {
        print('Day la MayNode');
        return MapNode.fromJson(e);
      } else {
        print('Day la MapWay');
        return MapWay.fromJson(e);
      }
    }).toList();
  }
}

class Bounds {
  Bounds({
    required this.minlat,
    required this.minlon,
    required this.maxlat,
    required this.maxlon,
  });
  late final double minlat;
  late final double minlon;
  late final double maxlat;
  late final double maxlon;

  Bounds.fromJson(Map<String, dynamic> json) {
    minlat = json['minlat'];
    minlon = json['minlon'];
    maxlat = json['maxlat'];
    maxlon = json['maxlon'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['minlat'] = minlat;
    _data['minlon'] = minlon;
    _data['maxlat'] = maxlat;
    _data['maxlon'] = maxlon;
    return _data;
  }
}

class MapNode {
  MapNode({
    required this.type,
    required this.id,
    required this.lat,
    required this.lon,
    required this.timestamp,
    required this.version,
    required this.changeset,
    required this.user,
    required this.uid,
  });
  late final String type;
  late final int id;
  late final double lat;
  late final double lon;
  late final String timestamp;
  late final int version;
  late final int changeset;
  late final String user;
  late final int uid;

  MapNode.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    lat = json['lat'];
    lon = json['lon'];
    timestamp = json['timestamp'];
    version = json['version'];
    changeset = json['changeset'];
    user = json['user'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['id'] = id;
    _data['lat'] = lat;
    _data['lon'] = lon;
    _data['timestamp'] = timestamp;
    _data['version'] = version;
    _data['changeset'] = changeset;
    _data['user'] = user;
    _data['uid'] = uid;
    return _data;
  }
}

class MapWay {
  MapWay({
    required this.type,
    required this.id,
    required this.timestamp,
    required this.version,
    required this.changeset,
    required this.user,
    required this.uid,
    required this.nodes,
    required this.tags,
  });
  late final String type;
  late final int id;
  late final String timestamp;
  late final int version;
  late final int changeset;
  late final String user;
  late final int uid;
  late final List<int> nodes;
  late final Tags tags;

  MapWay.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    timestamp = json['timestamp'];
    version = json['version'];
    changeset = json['changeset'];
    user = json['user'];
    uid = json['uid'];
    nodes = List.castFrom<dynamic, int>(json['nodes']);
    tags = Tags.fromJson(json['tags']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['id'] = id;
    _data['timestamp'] = timestamp;
    _data['version'] = version;
    _data['changeset'] = changeset;
    _data['user'] = user;
    _data['uid'] = uid;
    _data['nodes'] = nodes;
    _data['tags'] = tags.toJson();
    return _data;
  }
}

class Tags {
  Tags({
    required this.activeTrafficManagement,
    required this.bicycle,
    required this.carriagewayRef,
    required this.description,
    required this.foot,
    required this.highway,
    required this.horse,
    required this.intRef,
    required this.lanes,
    required this.lit,
    required this.maxspeed,
    required this.maxspeedtype,
    required this.maxspeedvariable,
    required this.motorVehicle,
    required this.nationalHighwaysarea,
    required this.oneway,
    required this.operator,
    required this.operatorwikidata,
    required this.operatorwikipedia,
    required this.ref,
    required this.surface,
  });
  late final String? activeTrafficManagement;
  late final String? bicycle;
  late final String? carriagewayRef;
  late final String? description;
  late final String? foot;
  late final String? highway;
  late final String? horse;
  late final String? intRef;
  late final String? lanes;
  late final String? lit;
  late final String? maxspeed;
  late final String? maxspeedtype;
  late final String? maxspeedvariable;
  late final String? motorVehicle;
  late final String? nationalHighwaysarea;
  late final String? oneway;
  late final String? operator;
  late final String? operatorwikidata;
  late final String? operatorwikipedia;
  late final String? ref;
  late final String? surface;

  Tags.fromJson(Map<String, dynamic> json) {
    activeTrafficManagement = json['active_traffic_management'];
    bicycle = json['bicycle'];
    carriagewayRef = json['carriageway_ref'];
    description = json['description'];
    foot = json['foot'];
    highway = json['highway'];
    horse = json['horse'];
    intRef = json['int_ref'];
    lanes = json['lanes'];
    lit = json['lit'];
    maxspeed = json['maxspeed'];
    maxspeedtype = json['maxspeed:type'];
    maxspeedvariable = json['maxspeed:variable'];
    motorVehicle = json['motor_vehicle'];
    nationalHighwaysarea = json['national_highways:area'];
    oneway = json['oneway'];
    operator = json['operator'];
    operatorwikidata = json['operator:wikidata'];
    operatorwikipedia = json['operator:wikipedia'];
    ref = json['ref'];
    surface = json['surface'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['active_traffic_management'] = activeTrafficManagement;
    _data['bicycle'] = bicycle;
    _data['carriageway_ref'] = carriagewayRef;
    _data['description'] = description;
    _data['foot'] = foot;
    _data['highway'] = highway;
    _data['horse'] = horse;
    _data['int_ref'] = intRef;
    _data['lanes'] = lanes;
    _data['lit'] = lit;
    _data['maxspeed'] = maxspeed;
    _data['maxspeed:type'] = maxspeedtype;
    _data['maxspeed:variable'] = maxspeedvariable;
    _data['motor_vehicle'] = motorVehicle;
    _data['national_highways:area'] = nationalHighwaysarea;
    _data['oneway'] = oneway;
    _data['operator'] = operator;
    _data['operator:wikidata'] = operatorwikidata;
    _data['operator:wikipedia'] = operatorwikipedia;
    _data['ref'] = ref;
    _data['surface'] = surface;
    return _data;
  }
}

class Uid {
  Uid({
    required this.addrcity,
    required this.addrdistrict,
    required this.addrhousenumber,
    required this.addrprovince,
    required this.addrstreet,
    required this.addrsubdistrict,
    required this.building,
    required this.buildinglevels,
    required this.height,
    required this.name,
  });
  late final String addrcity;
  late final String addrdistrict;
  late final String addrhousenumber;
  late final String addrprovince;
  late final String addrstreet;
  late final String addrsubdistrict;
  late final String building;
  late final String buildinglevels;
  late final String height;
  late final String name;

  Uid.fromJson(Map<String, dynamic> json) {
    addrcity = json['addr:city'];
    addrdistrict = json['addr:district'];
    addrhousenumber = json['addr:housenumber'];
    addrprovince = json['addr:province'];
    addrstreet = json['addr:street'];
    addrsubdistrict = json['addr:subdistrict'];
    building = json['building'];
    buildinglevels = json['building:levels'];
    height = json['height'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['addr:city'] = addrcity;
    _data['addr:district'] = addrdistrict;
    _data['addr:housenumber'] = addrhousenumber;
    _data['addr:province'] = addrprovince;
    _data['addr:street'] = addrstreet;
    _data['addr:subdistrict'] = addrsubdistrict;
    _data['building'] = building;
    _data['building:levels'] = buildinglevels;
    _data['height'] = height;
    _data['name'] = name;
    return _data;
  }
}
