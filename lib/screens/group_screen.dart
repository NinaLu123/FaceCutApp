/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */
import 'package:backgroundremove/Model/Record.dart';
import 'package:backgroundremove/screens/third_phase_screen.dart';
import 'package:backgroundremove/widgets/GroupGrid.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'home_screen.dart';

class GroupScreen extends StatefulWidget {
  GroupScreen();

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  var recordList = <Record>[];

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    List<dynamic> data = box.read("Records") ?? [];
    recordList = data.map<Record>((item) => Record.fromJson(item)).toList();
    recordList.add(Record(profile: 2, gender: 1, photoPath: 'assets/user1.png',));
    recordList.add(Record(profile: 2, gender: 2, photoPath: 'assets/user2.png',));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          //padding: EdgeInsets.symmetric(vertical: 30.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 70.0, top: 30.0),
              child: Align(
                alignment: FractionalOffset.topLeft,
                child: Text('Group',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                child: FutureBuilder(
                  builder: (context, status) {
                    return GroupGrid(records: recordList);
                  },
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              onPressed: () async {
                                if (recordList.length > 4) {
                                  await _showDialog(
                                      'You have already added five people in the existing group');
                                } else {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomeScreen()));
                                }
                              },
                              child: Text(
                                'Add another image',
                                style: TextStyle(
                                    color: recordList.length > 4
                                        ? Colors.grey
                                        : Colors.white,
                                    fontSize: 16.0),
                              ),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor))),
                          SizedBox(width: 30),
                          OutlinedButton(
                              onPressed: () async {
                                if (getSelectedCount(recordList) > 0) {
                                  List<Record> records = [];
                                  for (int i = 0; i < recordList.length; i++) {
                                    if (recordList[i].selected) {
                                      records.add(recordList[i]);
                                    }
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ThirdPhaseScreen(
                                                records: records,
                                              )));
                                } else {
                                  await _showDialog(
                                      'Please select at least one image to process');
                                }
                              },
                              child: Text(
                                'Process Images',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0),
                              ),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                _showDeleteDialog(
                                    'Do you want to delete all cropped faces?');
                              },
                              child: Text(
                                'Cancel the entire process',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0),
                              ),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int getSelectedCount(List<Record> list) {
    int selected = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].selected) {
        setState(() {
          selected++;
        });
      }
    }
    return selected;
  }

  Future<void> _showDeleteDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                removeRecordInLocal();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  removeRecordInLocal() async {
    final box = GetStorage();
    recordList.clear();
    box.remove('Records');
    setState(() {});
    Navigator.of(context).pop();
  }
}
