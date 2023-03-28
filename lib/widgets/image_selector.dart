/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:backgroundremove/Model/Record.dart';
import 'package:backgroundremove/Model/dataModel.dart';
import 'package:backgroundremove/screens/group_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';

class ImageSelector extends StatefulWidget {
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File _image = File('');
  bool waitingRequest = false;
  File _croppedImage = File('');
  DataModel _userTypeValue = DataModel(1, 'Kid');
  List<DataModel> _userTypes = <DataModel>[
    DataModel(1, 'Kid'),
    DataModel(2, 'Adult')
  ];
  DataModel _genderValue = DataModel(1, 'Male');
  List<DataModel> _genderTypes = <DataModel>[
    DataModel(1, 'Male'),
    DataModel(2, 'Female'),
    DataModel(3, 'Others')
  ];
  var recordList = <Record>[];

  late Directory tempDir1;
  int imageCount = 0;

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    List<dynamic> data = box.read("Records") ?? [];
    recordList = data.map<Record>((item) => Record.fromJson(item)).toList();
    imageCount = recordList.length;
    setState(() {});
  }

// method for background removal written by Ashwani(HashTag Labs Pvt Ltd)
  removeBackground() async {
    setState(() {
      waitingRequest = true;
    });

    String url = 'https://www.cutout.pro/api/v1/matting?mattingType=3';
    //for multipartrequest
    var request = http.MultipartRequest('POST', Uri.parse(url));

    //for token
    request.headers.addAll({"APIKEY": "6b2b727565644cf6a47402c5d6e97f74"});
    // request.headers.addAll({"APIKEY": "YOUR_TEST_KEY"});
    request.files.add(await http.MultipartFile.fromPath("file", _image.path));
    var responsed;
    try {
      //for completing the request

      var response = await request.send();
      //for getting and decoding the response into json format
      responsed = await http.Response.fromStream(response);
      if (responsed.bodyBytes.length > 200) {
        final tempDir = await getTemporaryDirectory();
        // create and save croppedImage to temporary directory
        String filename = '${DateTime.now().toUtc().toIso8601String()}.png';
        try {
          File fileTemp = new File('${tempDir.path}/$filename');
          await fileTemp.writeAsBytes(responsed.bodyBytes);
          _croppedImage = fileTemp;
        } on Exception catch (e) {
          await _showDialog('An error happened while saving cropped image.');
          print(e);
        }
      } else {
        final responseData = json.decode(responsed.body);
        if (responseData["code"] == 1001) {
          await _showDialog('Request failed');
        } else if (responseData["code"] == 1002) {
          await _showDialog('File size must be less than 10M');
        } else if (responseData["code"] == 4001) {
          await _showDialog('Your credits is not enough');
        } else if (responseData["code"] == 4002) {
          await _showDialog('File not exist');
        } else if (responseData["code"] == 5002) {
          await _showDialog('Invalid api key');
        } else if (responseData["code"] == 5003) {
          await _showDialog('Matting failed');
        } else if (responseData["code"] == 5004) {
          await _showDialog('Image url download failed');
        } else if (responseData["code"] == 5005) {
          await _showDialog('Query per second limited');
        } else if (responseData["code"] == 5006) {
          await _showDialog('Invalid base64 string');
        } else if (responseData["code"] == 5007) {
          await _showDialog('Base64 string can not be recognized as image');
        } else if (responseData["code"] == 5008) {
          await _showDialog('Input image can not be recognized as image');
        } else if (responseData["code"] == 7001) {
          await _showDialog('Face analysis failed');
        } else if (responseData["code"] == 7002) {
          await _showDialog('Multiple person detected');
        } else {
          await _showDialog('Something went wrong');
        }
      }
    } catch (e) {
      print("ERROR");
      final responseData = json.decode(responsed.body);
      if (responseData["code"] == 1001) {
        await _showDialog('Request failed');
      } else if (responseData["code"] == 1002) {
        await _showDialog('File size must be less than 10M');
      } else if (responseData["code"] == 4001) {
        await _showDialog('Your credits is not enough');
      } else if (responseData["code"] == 4002) {
        await _showDialog('File not exist');
      } else if (responseData["code"] == 5002) {
        await _showDialog('Invalid api key');
      } else if (responseData["code"] == 5003) {
        await _showDialog('Matting failed');
      } else if (responseData["code"] == 5004) {
        await _showDialog('Image url download failed');
      } else if (responseData["code"] == 5005) {
        await _showDialog('Query per second limited');
      } else if (responseData["code"] == 5006) {
        await _showDialog('Invalid base64 string');
      } else if (responseData["code"] == 5007) {
        await _showDialog('Base64 string can not be recognized as image');
      } else if (responseData["code"] == 5008) {
        await _showDialog('Input image can not be recognized as image');
      } else if (responseData["code"] == 7001) {
        await _showDialog('Face analysis failed');
      } else if (responseData["code"] == 7002) {
        await _showDialog('Multiple person detected');
      } else {
        await _showDialog('Something went wrong');
      }
    }
    setState(() {
      waitingRequest = false;
    });
  }

  Future<void> _showDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cropping Info'),
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

  saveCroppedImage() async {
    if (_croppedImage.path != '') {
      final imgDir = Directory(
          '${(await getApplicationDocumentsDirectory()).path}/facecut');
      // create and save croppedImage to temporary directory
      String filename = '${DateTime.now().toUtc().toIso8601String()}.png';
      try {
        File fileDoc = new File('${imgDir.path}/$filename');
        // then, save it to the gallery
        await _croppedImage.copy(fileDoc.path);
        GallerySaver.saveImage(fileDoc.path);
        saveRecordInLocal(fileDoc.path);
      } on Exception catch (e) {
        await _showDialog('An error happened while saving cropped image.');
        print(e);
      }
    } else {
      await _showDialog('Please process image first.');
    }
  }

  saveRecordInLocal(String path) async {
    final box = GetStorage();
    recordList.add(Record(
        profile: _userTypeValue.id!,
        gender: _genderValue.id!,
        photoPath: path));
    box.write("Records", recordList.map((record) => record.toJson()).toList());
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => GroupScreen()));
  }

  Future<void> _showImagePickerDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Select source of the image you want to crop."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('From camera'),
              onPressed: () {
                selectImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('From gallery'),
              onPressed: () {
                selectImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future selectImage(ImageSource src) async {
    ImagePicker impick = new ImagePicker();
    var image = await impick.getImage(source: src, imageQuality: 60);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !waitingRequest
        ? Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _croppedImage.path == '' ? 'Take new image' : 'Step 2',
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(19.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (imageCount > 4) {
                          await _showDialog(
                              'You have already added five people in the existing group');
                        } else {
                          _showImagePickerDialog();
                        }
                      },
                      child: Container(
                        child: _image.path == ''
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(FontAwesomeIcons.solidImage,
                                    color: Colors.black12, size: 200),
                              )
                            : Image.file(
                                _croppedImage.path == ''
                                    ? _image
                                    : _croppedImage,
                                width: 250),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0, 2.0),
                                blurRadius: 6.0)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _image.path != '' && _croppedImage.path == '',
                    child: OutlinedButton(
                        onPressed: () async {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            removeBackground();
                          } else {
                            await _showDialog('Please connect to internet.');
                          }
                        },
                        child: Text(
                          'Process Image',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor))),
                  ),
                  Visibility(
                    visible: _croppedImage.path != '',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Profile Info',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        RadioGroup<DataModel>.builder(
                          horizontalAlignment: MainAxisAlignment.start,
                          direction: Axis.horizontal,
                          groupValue: _userTypeValue,
                          onChanged: (value) => setState(() {
                            _userTypeValue = value!;
                          }),
                          items: _userTypes,
                          itemBuilder: (item) => RadioButtonBuilder(
                            item.title!,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Gender',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        RadioGroup<DataModel>.builder(
                          horizontalAlignment: MainAxisAlignment.start,
                          direction: Axis.horizontal,
                          groupValue: _genderValue,
                          onChanged: (value) => setState(() {
                            _genderValue = value!;
                          }),
                          items: _genderTypes,
                          itemBuilder: (item) => RadioButtonBuilder(
                            item.title!,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _image = File('');
                                    _croppedImage = File('');
                                  });
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor))),
                            SizedBox(width: 20),
                            OutlinedButton(
                                onPressed: () {
                                  saveCroppedImage();
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        : SpinKitFadingFour(color: Colors.black38, size: 160);
  }
}
