import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:connectivity/connectivity.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:location/location.dart';

import 'package:checkschool/MainPage/Signup.dart';
import 'package:checkschool/MainPage/MainMenu.dart';
import '../SchoolWIfiName.dart';
import 'Setting.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}
class _CheckState extends State<Check> {
  var subscription;

  @override
  initState() {
    super.initState();

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      setState(() {
      });
    });
  }
  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  bool first = true;
  var _currentPage = 0;

  var uid;
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
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("1");
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        list["Network"] = "NotLocationData";
        return list;
      }
    }

    _locationData = await location.getLocation();

    //#endregion\

    //#regioncheck wifi
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: CheckStates(),
        builder:(context,snapshot){
          if(snapshot.hasData){
            if(snapshot.data["Network"] != "NotLocationData"){
              if(snapshot.data["Network"] != "None"){
                if(_currentPage == 0){
                  return MainPage(snapshot.data["Network"],SchoolName,uid);
                }else{
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("Sign Up",style: TextStyle(fontSize: 30,color: Colors.black)),
                    ),
                    body: SignUp(SchoolName,uid),
                  );
                }
              }else{
                return Scaffold(
                  body: Center(child: Text("인터넷을 연결해주세요.",style: TextStyle(fontSize: 20,color: Colors.black),)),
                );
              }

            }else{
              return Scaffold(
                body: Center(child: Text("위치정보를 허용해주세요.",style: TextStyle(fontSize: 20,color: Colors.black),)),
              );
            }

          }else{
            return Scaffold(
              body: Center(child: CupertinoActivityIndicator()),
            );
          }
        }
    );
  }
}