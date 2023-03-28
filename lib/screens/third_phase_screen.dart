/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:backgroundremove/Model/processed_record.dart';
import 'package:backgroundremove/app_constants.dart';
import 'package:backgroundremove/screens/processed_images_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image/image.dart' as image;
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:color_models/color_models.dart';
import '../api_requests/coordinates_request.dart';

import '../Model/Record.dart';
import '../Model/jsondataModel.dart';

class ThirdPhaseScreen extends StatefulWidget {
  var records = <Record>[];

  ThirdPhaseScreen({required this.records});

  @override
  _ThirdPhaseScreenScreenState createState() => _ThirdPhaseScreenScreenState();
}

class _ThirdPhaseScreenScreenState extends State<ThirdPhaseScreen> {
  //String _imageTypeValue = "Type A";
  String _imageTypeValue = "Ribeira";
  List<JsonDataModel> _imageCoordinates = [];
  //List<String> _imageTypes = ["Type A", "Type B", "Type C"];
  List<String> _imageTypes = ["Ribeira", "Type A", "Type B", "Type C"];
  bool waitingRequest = false;
  var processedRecordList = <ProcessedRecord>[];

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    List<dynamic> data = box.read("ProcessedRecords") ?? [];
    processedRecordList = data
        .map<ProcessedRecord>((item) => ProcessedRecord.fromJson(item))
        .toList();
    getJsonData();
  }

  void getJsonData() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/data.json");
    _imageCoordinates = jsonDataModelFromJson(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !waitingRequest
            ? Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 70.0, top: 30.0),
                    child: Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text('Merge Image',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, top: 20),
                            child: Text(
                              'Image to merge in : ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      RadioGroup<String>.builder(
                        horizontalAlignment: MainAxisAlignment.start,
                        direction: Axis.vertical,
                        groupValue: _imageTypeValue,
                        onChanged: (value) => setState(() {
                          _imageTypeValue = value!;
                        }),
                        items: _imageTypes,
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
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
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .primaryColor))),
                                SizedBox(width: 20),
                                OutlinedButton(
                                    onPressed: () async {
                                      processMultipleImage(_imageCoordinates,
                                          widget.records, _imageTypeValue);
                                    },
                                    child: Text(
                                      'Process',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .primaryColor))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : SpinKitFadingFour(color: Colors.black38, size: 160),
      ),
    );
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  // recordList é as fotos tiradas
  // listCoordinatesAll os possiveis sitios onde podem ficar
  processMultipleImage(List<JsonDataModel> listCoordinatesAll,
      List<Record> recordList, String selectedType) async {
    setState(() {
      waitingRequest = true;
    });

    List<JsonDataModel> listCoordinates = listCoordinatesAll.where((x) => x.imageType == selectedType).toList();

    File dst1 = new File('');


    if (selectedType == "Ribeira") {
      dst1 = await getImageFileFromAssets('Type A.png');
    } else if (selectedType == "Type A") {
      dst1 = await getImageFileFromAssets('Type A.png');
      // dst1 = await getImageFileFromAssets('Type A.jpg');
    } else if (selectedType == "Type B") {
      dst1 = await getImageFileFromAssets('Type B.jpg');
    } else if (selectedType == "Type C") {
      dst1 = await getImageFileFromAssets('Type C.jpg');
    }
    final tmpdst = dst1.readAsBytesSync();

  final dst = image.decodePng(tmpdst);


  for (int i = 0; i < recordList.length; i++) {
  var genderId = recordList[i].gender;
   String gender = '';
        if(genderId == 1){
          gender = 'Male';
        } else if(genderId == 2){
          gender = 'Female';
        }else{
          gender = 'Others';
        }
  
      JsonDataModel model = listCoordinates
        .where((food) => food.imageType == selectedType && food.people?.any((element) => element.gender== gender)==true).first;

      image.Image? src;
      if (recordList[i].photoPath.contains('assets/user')) {
        File tt = await getImageFileFromAssets(recordList[i].photoPath
            .substring(recordList[i].photoPath
            .indexOf('/')+1));
        src = image.decodeImage(tt.readAsBytesSync());
      } else {
        src =
            image.decodeImage(File(recordList[i].photoPath).readAsBytesSync());
      }
          src = image.copyResize(src!, width: model.people!.first.size!.width);

          image.copyInto(dst!, src,
              dstX: model.people!.first.point!.x,
              dstY: model.people!.first.point!.y,
              blend: true);
          listCoordinates.remove(model);
    }

  // print o resto das imagens nos seus respectivos lugares
  for (int i = 0; i < listCoordinates.length; i++) {
  
    JsonDataModel model = listCoordinates
        .where((food) => food.imageType == selectedType).first;

    File tt1 = await getImageFileFromAssets(model.imageName!);
    image.Image? src1 = image.decodeImage(tt1.readAsBytesSync());
    //src1 = image.copyResize(src1!, width: dst?.width, height: dst?.height);


    src1 = image.copyResize(src1!, width: model.people!.first.size!.width);

          image.copyInto(dst!, src1,
              dstX: model.people!.first.point!.x,
              dstY: model.people!.first.point!.y,
              blend: true);
          listCoordinates.remove(model);

    image.copyInto(dst!, src1!, blend: true);

    listCoordinates.remove(model);
  }

// add type 
// Add userid 

    var idToPrint = await coordinatesRequest(recordList);

    final tempDir = await getTemporaryDirectory();
    // create and save croppedImage to temporary directory
    String filename =
        'MergedImage_${idToPrint}_${DateTime.now().toUtc().toIso8601String()}.png';
    try {
      File fileTemp = new File('${tempDir.path}/$filename');
      fileTemp.writeAsBytesSync(image.encodePng(dst!));
      GallerySaver.saveImage(fileTemp.path);
      saveRecordInLocal(fileTemp.path, selectedType);
    } on Exception catch (e) {
      print(e);
    }
    setState(() {
      waitingRequest = false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => ProcessedImageScreen()));
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

  saveRecordInLocal(String path, String type) async {
    final box = GetStorage();
    processedRecordList.add(ProcessedRecord(photoPath: path, type: type));
    box.write("ProcessedRecords",
        processedRecordList.map((record) => record.toJson()).toList());
  }
}
