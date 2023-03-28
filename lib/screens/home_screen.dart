/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */
import 'dart:io';

import 'package:backgroundremove/screens/processed_images_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'HistoryPage.dart';
import '../widgets/image_selector.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  late Directory tempDir;
  int imageCount = 0;

  _initializeDirectory() async {
    tempDir =
        Directory('${(await getApplicationDocumentsDirectory()).path}/facecut');
    var imageList = tempDir
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".png"))
        .toList(growable: false);
    setState(() {
      imageCount = imageList.length;
      print(imageCount);
    });
  }

  @override
  void initState() {
    _initializeDirectory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 70.0),
              child: Text('Face Cut',
                  style:
                      TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20.0),
            ImageSelector(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentTab,
        color: Colors.black87,
        backgroundColor: Colors.transparent,
        height: 55,
        items: <Widget>[
          Icon(FontAwesomeIcons.cropAlt,
              size: 25, color: Theme.of(context).primaryColor),
          Icon(FontAwesomeIcons.images,
              size: 25, color: Theme.of(context).primaryColor),
          Icon(FontAwesomeIcons.solidImages,
              size: 25, color: Theme.of(context).primaryColor),
        ],
        animationDuration: Duration(milliseconds: 220),
        animationCurve: Curves.easeInOutSine,
        onTap: (index) {
          if (_currentTab != index) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
                break;
              case 1:
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => HistoryScreen()));
                break;
              case 2:
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => ProcessedImageScreen()));
                break;
              default:
                break;
            }
          }
          _currentTab = index;
        },
      ),
    );
  }
}
