// To parse this JSON data, do
//
//     final jsonDataModel = jsonDataModelFromJson(jsonString);

import 'dart:convert';

List<JsonDataModel> jsonDataModelFromJson(String str) => List<JsonDataModel>.from(json.decode(str).map((x) => JsonDataModel.fromJson(x)));

String jsonDataModelToJson(List<JsonDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JsonDataModel {
  JsonDataModel({
    this.imageName,
    this.imageType,
    this.people,
  });

  String? imageName;
  String? imageType;
  List<Person>? people;

  factory JsonDataModel.fromJson(Map<String, dynamic> json) => JsonDataModel(
    imageName: json["image_name"],
    imageType: json["image_type"],
    people: List<Person>.from(json["people"].map((x) => Person.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "image_name": imageName,
    "image_type": imageType,
    "people": List<dynamic>.from(people!.map((x) => x.toJson())),
  };
}

class Person {
  Person({
    this.point,
    this.size,
    this.gender,
    this.profile,
  });

  Point? point;
  Size? size;
  String? gender;
  String? profile;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    point: Point.fromJson(json["point"]),
    size: Size.fromJson(json["size"]),
    gender: json["gender"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "point": point!.toJson(),
    "size": size!.toJson(),
    "gender": gender,
    "profile": profile,
  };
}

class Point {
  Point({
    this.x,
    this.y,
  });

  int? x;
  int? y;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    x: json["x"],
    y: json["y"],
  );

  Map<String, dynamic> toJson() => {
    "x": x,
    "y": y,
  };
}

class Size {
  Size({
    this.height,
    this.width,
  });

  int? height;
  int? width;

  factory Size.fromJson(Map<String, dynamic> json) => Size(
    height: json["height"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "width": width,
  };
}
