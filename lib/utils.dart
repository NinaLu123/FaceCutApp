/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

Future<void> requestPermissions() async {
  await Permission.mediaLibrary.request();
  await Permission.photos.request();
  await Permission.storage.request();
}


Future checkAndCreateDataFolder() async {
  final imgDir =
      Directory('${(await getApplicationDocumentsDirectory()).path}/facecut');
  imgDir.exists().then((isThere) {
    if (!isThere) {
      imgDir.create(recursive: true).then((Directory directory) {
        print('created /facecut folder under app storage');
      });
    }
  });
}
