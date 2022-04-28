// class MapNotes {
//   MapNotes({
//     required this.type,
//     required this.features,
//   });
//   late final String type;
//   late final List<Features> features;
  
//   MapNotes.fromJson(Map<String, dynamic> json){
//     type = json['type'];
    // features = List.from(json['features']).map((e)=>Features.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['type'] = type;
//     _data['features'] = features.map((e)=>e.toJson()).toList();
//     return _data;
//   }
// }

// class Features {
//   Features({
//     required this.type,
//     required this.geometry,
//     required this.properties,
//   });
//   late final String type;
//   late final Geometry geometry;
//   late final Properties properties;
  
//   Features.fromJson(Map<String, dynamic> json){
//     type = json['type'];
//     geometry = Geometry.fromJson(json['geometry']);
//     properties = Properties.fromJson(json['properties']);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['type'] = type;
//     _data['geometry'] = geometry.toJson();
//     _data['properties'] = properties.toJson();
//     return _data;
//   }
// }

// class Geometry {
//   Geometry({
//     required this.type,
//     required this.coordinates,
//   });
//   late final String type;
//   late final List<double> coordinates;
  
//   Geometry.fromJson(Map<String, dynamic> json){
//     type = json['type'];
//     coordinates = List.castFrom<dynamic, double>(json['coordinates']);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['type'] = type;
//     _data['coordinates'] = coordinates;
//     return _data;
//   }
// }

// class Properties {
//   Properties({
//     required this.id,
//     required this.url,
//     required this.commentUrl,
//     required this.closeUrl,
//     required this.dateCreated,
//     required this.status,
//     required this.comments,
//   });
//   late final int id;
//   late final String url;
//   late final String commentUrl;
//   late final String closeUrl;
//   late final String dateCreated;
//   late final String status;
//   late final List<Comments> comments;
  
//   Properties.fromJson(Map<String, dynamic> json){
//     id = json['id'];
//     url = json['url'];
//     commentUrl = json['comment_url'];
//     closeUrl = json['close_url'];
//     dateCreated = json['date_created'];
//     status = json['status'];
//     comments = List.from(json['comments']).map((e)=>Comments.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['url'] = url;
//     _data['comment_url'] = commentUrl;
//     _data['close_url'] = closeUrl;
//     _data['date_created'] = dateCreated;
//     _data['status'] = status;
//     _data['comments'] = comments.map((e)=>e.toJson()).toList();
//     return _data;
//   }
// }

// class Comments {
//   Comments({
//     required this.date,
//     required this.action,
//     required this.text,
//     required this.html,
//   });
//   late final String date;
//   late final String? action;
//   late final String text;
//   late final String html;
  
//   Comments.fromJson(Map<String, dynamic> json){
//     date = json['date'];
//     action = json['action'];
//     text = json['text'];
//     html = json['html'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['date'] = date;
//     _data['action'] = action;
//     _data['text'] = text;
//     _data['html'] = html;
//     return _data;
//   }
// }