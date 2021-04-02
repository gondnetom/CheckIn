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
import 'Setting.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}
class _CheckState extends State<Check> {
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
  var subscription;

  String SchoolName;
  var uid;

  Future CheckStates() async{
    var list = Map();

    //Get Android location data
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
        return;
      }
    }

    _locationData = await location.getLocation();

    //check wifi
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      list["Network"] = "확인불가";
      print("wifiName");
    }
    else if (connectivityResult == ConnectivityResult.wifi) {
      var wifiName = await WifiInfo().getWifiName();
      switch(wifiName){
        case "gbshs":
          list["Network"] = "자습실, 교실";
          break;
        case "LIBRARY_2.4G":
        case "LIBRARY_5G":
          list["Network"] = "도서실";
          break;

        case "Sound Room 2.4G":
        case "Sound Room 5G":
          list["Network"] = "음악실";
          break;

        case "Note_Station2":
          list["Network"] = "NoteStation2";
          break;

        case "gbshs_com1":
          list["Network"] = "컴퓨터실1";
          break;
        case "GBSHS_COM2":
          list["Network"] = "컴퓨터실2";
          break;

        case "GBS_EAR11":
        case "GBS_EAR11_5G":
        case "GBS_EAR":
        case "GBS_EAR_5G":
          list["Network"] = "지구과학실1";
          break;
        case "GBS_EAR22":
        case "GBS_EAR22_5G":
        case "GBS_EAR2":
        case "GBS_EAR2_5G":
          list["Network"] = "지구과학실2";
          break;

        case "GBS_PHY11":
        case "GBS_PHY11_5G":
        case "GBS_PHY":
        case "GBS_PHY_5G":
          list["Network"] = "물리실1";
          break;
        case "GBS_PHY22":
        case "GBS_PHY22_5G":
        case "GBS_PHY2":
        case "GBS_PHY2_5G":
          list["Network"] = "물리실2";
          break;

        case "GBS_CHE11":
        case "GBS_CHE11_5G":
        case "GBS_CHE":
        case "GBS_CHE_5G":
          list["Network"] = "화학실1";
          break;
        case "GBS_CHE22":
        case "GBS_CHE22_5G":
        case "GBS_CHE2":
        case "GBS_CHE2_5G":
        case "CHE2_2.4G":
          list["Network"] = "화학실2";
          break;

        case "GBS_BIO11":
        case "GBS_BIO11_5G":
        case "GBS_BIO":
        case "GBS_BIO_5G":
          list["Network"] = "생명실1";
          break;
        case "GBS_BIO22":
        case "GBS_BIO22_5G":
        case "GBS_BIO2":
        case "GBS_BIO2_5G":
          list["Network"] = "생명실2";
          break;

        default:
          list["Network"] = "확인불가";
          break;
      }
    }
    else{
      list["Network"] = "None";
    }


    //check my id
    if(first && list["Network"] != "None"){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      SchoolName = await prefs.getString("SchoolName") ?? "";
      uid = await FirebaseAuth.instance.currentUser.uid;

      if(SchoolName == ""){
        await FirebaseAuth.instance.signOut();
        return;
      }

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

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_currentPage==0 ?"Menu":"SignUp"}",style: TextStyle(fontSize: 30,color: Colors.black)),
        actions: [
          IconButton(
            icon:Icon(CupertinoIcons.settings,color: Colors.black,),
            onPressed: (){
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => Setting(),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: CheckStates(),
          builder:(context,snapshot){
            if(snapshot.hasData){
              if(snapshot.data["Network"] == "None"){
                return Center(child: Text("인터넷을 연결해주세요.",style: TextStyle(fontSize: 20,color: Colors.black),));
              }else{
                if(_currentPage==0)
                  return MainPage(snapshot.data["Network"],SchoolName,uid);
                else
                  return SignUp(SchoolName,uid);
              }
            }else{
              return Center(child: CupertinoActivityIndicator());
            }
          }
      ),
    );
  }
}