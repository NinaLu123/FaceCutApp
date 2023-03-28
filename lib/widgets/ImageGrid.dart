/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */
import 'dart:io';
import 'package:backgroundremove/screens/image_screen.dart';
import 'package:flutter/material.dart';

class ImageGrid extends StatelessWidget {
  final Directory directory;

  const ImageGrid({required this.directory});

  @override
  Widget build(BuildContext context) {
    var imageList = directory
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".png"))
        .toList(growable: false);
    return GridView.builder(
      shrinkWrap: true,
      itemCount: imageList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 3.0 / 3.0),
      itemBuilder: (context, index) {
        File file = new File(imageList[index]);
        String name = file.path.split('/').last;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageScreen(image: imageList[index]),
                ),
              ),
              child: Padding(
                padding: new EdgeInsets.all(4.0),
                child: Image.file(
                  File(imageList[index]),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
