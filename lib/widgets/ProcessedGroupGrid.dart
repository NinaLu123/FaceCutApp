/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */
import 'dart:io';

import 'package:backgroundremove/Model/Record.dart';
import 'package:backgroundremove/Model/processed_record.dart';
import 'package:backgroundremove/screens/image_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';

class ProcessedGroupGrid extends StatefulWidget {
  var records = <ProcessedRecord>[];

  ProcessedGroupGrid({required this.records});

  @override
  _GroupGridState createState() => _GroupGridState();
}

class _GroupGridState extends State<ProcessedGroupGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.records.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 3.0 / 4.0),
      itemBuilder: (context, index) {
        String type = widget.records[index].type;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ImageScreen(image: widget.records[index].photoPath),
              ),
            ),
            child: Padding(
              padding: new EdgeInsets.all(4.0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(widget.records[index].photoPath)),
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: Colors.deepOrangeAccent,
                                  label: Text(type,
                                      style: TextStyle(fontSize: 11))),
                              GestureDetector(
                                  onTap: () {
                                    Share.shareFiles(
                                        [widget.records[index].photoPath],
                                        text: type);
                                  },
                                  child: Icon(Icons.share))
                            ],
                          ),
                        )),
                    // child: Image.file(
                    //   File(records[index].photoPath),
                    //   fit: BoxFit.contain,
                    // ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDeleteDialog('Do you want to delete?', index);
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
    box.write("ProcessedRecords",
        widget.records.map((record) => record.toJson()).toList());
    setState(() {});
    Navigator.of(context).pop();
  }
}
