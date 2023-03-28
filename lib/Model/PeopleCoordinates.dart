// To parse this JSON data, do
//
//     final peopleCoordinates = peopleCoordinatesFromJson(jsonString);

import 'dart:convert';

PeopleCoordinates peopleCoordinatesFromJson(String str) => PeopleCoordinates.fromJson(json.decode(str));

String peopleCoordinatesToJson(PeopleCoordinates data) => json.encode(data.toJson());

class PeopleCoordinates {
  PeopleCoordinates({
    this.peopleCoordinates,
  });

  List<PeopleCoordinate>? peopleCoordinates;

  factory PeopleCoordinates.fromJson(Map<String, dynamic> json) => PeopleCoordinates(
    peopleCoordinates: List<PeopleCoordinate>.from(json["peopleCoordinates"].map((x) => PeopleCoordinate.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "peopleCoordinates": List<dynamic>.from(peopleCoordinates!.map((x) => x.toJson())),
  };
}

class PeopleCoordinate {
  PeopleCoordinate({
    this.gender,
    this.age,
    this.x,
    this.y,
  });

  int? gender;
  int? age;
  int? x;
  int? y;

  factory PeopleCoordinate.fromJson(Map<String, dynamic> json) => PeopleCoordinate(
    gender: json["gender"],
    age: json["age"],
    x: json["x"],
    y: json["y"],
  );

  Map<String, dynamic> toJson() => {
    "gender": gender,
    "age": age,
    "x": x,
    "y": y,
  };
}
