/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */
class ProcessedRecord {
  final String photoPath;
  final String type;

  ProcessedRecord({
    required this.photoPath,
    required this.type});

  Map<String, dynamic> toJson() {
    return {
      "photoPath": photoPath,
      "type": type
    };
  }

  static ProcessedRecord fromJson(dynamic json) {
    return ProcessedRecord(
        photoPath: json['photoPath'],
        type: json['type']);
  }
}