/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatelessWidget {
  final String image;

  ImageScreen({required this.image});

  // @override
  // _ImageScreenState createState() => _ImageScreenState();
// }

// class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    String img = image;
    return Container(
      child: PhotoView(
        imageProvider: !img
            .contains('assets/user') ? Image
            .file(File(img))
            .image : AssetImage(img),
      ),
    );
  }

}

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }
// }
