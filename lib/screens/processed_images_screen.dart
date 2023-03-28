/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */

import 'package:backgroundremove/widgets/ProcessedGroupGrid.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import '../Model/Record.dart';
import '../Model/processed_record.dart';
import 'HistoryPage.dart';
import 'home_screen.dart';

class ProcessedImageScreen extends StatefulWidget {
  ProcessedImageScreen();

  @override
  _ProcessedImageScreenState createState() => _ProcessedImageScreenState();
}

class _ProcessedImageScreenState extends State<ProcessedImageScreen> {
  int _currentTab = 2;
  var recordList = <ProcessedRecord>[];

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    List<dynamic> data = box.read("ProcessedRecords") ?? [];
    recordList = data.map<ProcessedRecord>((item) => ProcessedRecord.fromJson(item)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 70.0, top: 30.0, bottom: 30.0),
                child: Align(
                  alignment: FractionalOffset.topLeft,
                  child: Text('Processed Images',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 30.0),
                  child: Container(
                    child: FutureBuilder(
                      builder: (context, status) {
                        return ProcessedGroupGrid(records: recordList);
                      },
                    ),
                  ),
                ),
              ),
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
        ));
  }
}
