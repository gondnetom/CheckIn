import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:location/location.dart';

import 'package:checkschool/MainPage/Signup.dart';
import 'package:checkschool/MainPage/MainMenu.dart';
import 'package:checkschool/main.dart';
import '../SchoolWIfiName.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}
class _CheckState extends State<Check> {

  //#region Check Wifi and Alert
  var subscription;
  var _flutterLocalNotificationsPlugin;

  @override
  initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      setState(() {
        callbackDispatcherWifi();
      });
    });

    //일정시간에 알
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOS);

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _dailyAtTimeNotification();
  }
  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }
  Future<void> _dailyAtTimeNotification() async {
    var time = Time(21, 53, 0);
    var android = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high);
    var ios = IOSNotificationDetails();

    var detail = NotificationDetails(android: android,iOS: ios);

    await _flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      '출석체크를 해주세요!',
      '사감선생님이 당신을 찾고 있습니다!',
      time,
      detail,
      payload: 'CheckIn',
    );
  }
  //#endregion
  //#region Check Id
  bool first = true;
  int _currentPage = 0;

  String uid;
  String SchoolName;
  Future CheckStates() async{
    var list = Map();

    uid = await FirebaseAuth.instance.currentUser.uid;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    SchoolName = await prefs.getString("SchoolName") ?? "";
    if(SchoolName == ""){
      await FirebaseAuth.instance.signOut();
      return;
    }

    //#region Get location data
    if(_currentPage == 0){
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();

      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          list["Network"] = "NotLocationData";
        }
      }else{
        _locationData = await location.getLocation();
      }
    }
    //#endregion\
    //#regioncheck wifi
    if(list["Network"] != "NotLocationData"){
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        list["Network"] = "확인불가";
      }
      else if (connectivityResult == ConnectivityResult.wifi) {
        var wifiName = await WifiInfo().getWifiName();
        switch(SchoolName){
          case "경기북과학고등학교":
            list["Network"] =  GBSwifi(wifiName);
            break;

          default:
            break;
        }
      }
      else{
        list["Network"] = "None";
      }
    }
    //#endregion
    //#region check my id
    if(first && list["Network"] != "None"){
      final snapShot = await FirebaseFirestore.instance.collection("Users").doc(SchoolName).collection("Users").doc(uid).get();
      if (snapShot == null || !snapShot.exists) {
        setState(() {
          _currentPage = 1;
        });
      }else{
        first = false;
        setState(() {
          _currentPage = 0;
        });
      }
    }
    //#endregion

    return list;
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: CheckStates(),
        builder:(context,snapshot){
          if(snapshot.hasData){
            if(snapshot.data["Network"] == "None"){
              return Scaffold(
                body: Center(child: Text("인터넷을 연결해주세요.",style: TextStyle(fontSize: 20,color: Colors.black),)),
              );
            }
            else{
              if(_currentPage == 0){
                return MainPage(snapshot.data["Network"],SchoolName,uid);
              }
              else{
                return SignUp(SchoolName,uid);
              }
            }
          }
          else{
            return Scaffold(
              body: Center(child: CupertinoActivityIndicator()),
            );
          }
        }
    );
  }
}