/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */
class Record {
  final int profile;
  final int gender;
  final String photoPath;
  bool selected = true;

  Record({required this.profile,
        required this.gender,
        required this.photoPath});

  Map<String, dynamic> toJson() {
    return {
      "profile": profile,
      "gender": gender,
      "photoPath": photoPath
    };
  }

  static Record fromJson(dynamic json) {
    return Record(
        profile: json['profile'],
        gender: json['gender'],
        photoPath: json['photoPath']);
  }
}