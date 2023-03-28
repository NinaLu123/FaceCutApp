/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */
import 'dart:io';

import 'package:backgroundremove/Model/Record.dart';
import 'package:backgroundremove/screens/image_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class GroupGrid extends StatefulWidget {
  var records = <Record>[];

  GroupGrid({required this.records});

  @override
  _GroupGridState createState() => _GroupGridState();
}

class _GroupGridState extends State<GroupGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.records.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 3.0 / 4.0),
      itemBuilder: (context, index) {
        String profile = widget.records[index].profile == 1 ? "Kid" : "Adult";
        int gender = widget.records[index].gender;
        String genderText = '';
        if (gender == 1) {
          genderText = 'Male';
        } else if (gender == 2) {
          genderText = 'Female';
        } else {
          genderText = 'Others';
        }
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: InkWell(
            onTap: () {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ImageScreen(image: widget.records[index].photoPath),
                  ),
                );
              }
            },
            child: Padding(
              padding: new EdgeInsets.all(4.0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: !widget.records[index].photoPath
                                .contains('assets/user')
                            ? FileImage(File(widget.records[index].photoPath))
                            : Image.asset(widget.records[index].photoPath
                                    .substring(widget.records[index].photoPath
                                            .indexOf('/') +
                                        1))
                                .image,
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: Colors.deepOrangeAccent,
                                label: Text(profile,
                                    style: TextStyle(fontSize: 11))),
                            Chip(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: Colors.greenAccent,
                                label: Text(genderText,
                                    style: TextStyle(fontSize: 11))),
                          ],
                        )),
                    // child: Image.file(
                    //   File(records[index].photoPath),
                    //   fit: BoxFit.contain,
                    // ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.records[index].selected) {
                          widget.records[index].selected = false;
                        } else {
                          widget.records[index].selected = true;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.check,
                            color: widget.records[index].selected
                                ? Colors.green
                                : Colors.grey,
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDeleteDialog('Do you want to remove?', index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.cancel,
                            color: Colors.blue,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteDialog(String text, int index) async {
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
                removeRecordInLocal(index);
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

  removeRecordInLocal(int index) async {
    final box = GetStorage();
    widget.records.remove(widget.records[index]);
    box.write(
        "Records", widget.records.map((record) => record.toJson()).toList());
    setState(() {});
    Navigator.of(context).pop();
  }
}
