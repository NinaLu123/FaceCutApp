/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */
import 'package:backgroundremove/widgets/stateful_wrapper.dart';
import 'package:backgroundremove/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/home_screen.dart';

void main() async{
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        _initOnStartup().then((value) {
          print('init done');
        });
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Face Cut',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: SplashScreen(),
        home: HomeScreen(),
      ),
    );
  }
  Future _initOnStartup() async {
    requestPermissions();
    checkAndCreateDataFolder();
  }
}
