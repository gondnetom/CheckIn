import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:checkschool/Login/Home_Page.dart';
import 'package:workmanager/workmanager.dart';
import 'Login/google_sign_in.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'SchoolWIfiName.dart';

bool get isiOS => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async{
    await Firebase.initializeApp();

    String uid = await FirebaseAuth.instance.currentUser.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String SchoolName = await prefs.getString("SchoolName") ?? "";

    var date = await int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    var hour = await DateTime.now().hour;
    var minute = await DateTime.now().minute;

    String WifiName;
    int CheckDate;
    String NowLocation;

    if(SchoolName == ""){
      return Future.value(true);
    }
    if(!(hour>=18&&hour<=24)){
      return Future.value(true);
    }

    //#regioncheck wifi
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      WifiName = "확인불가";
    }
    else if (connectivityResult == ConnectivityResult.wifi) {
      var wifiName = await WifiInfo().getWifiName();
      switch(SchoolName){
        case "경기북과학고등학교":
          WifiName =  await GBSwifi(wifiName);
          break;

        default:
          break;
      }
    }
    else{
      WifiName = "None";
    }
    //#endregion
    //#region check my id
    if(WifiName != "None" &&  WifiName != "확인불가"){
      final snapShot = await FirebaseFirestore.instance.collection("Users").doc(SchoolName).collection("Users").doc(uid).get();
      if (snapShot == null || !snapShot.exists) {
        return Future.value(true);
      }else{
        await FirebaseFirestore.instance.collection("Users").doc(SchoolName).collection("Users").doc(uid).get().
        then((DocumentSnapshot ds){
          CheckDate = ds.get("Date");
          NowLocation = ds.get("NowLocation");
        });

        if(CheckDate == date && NowLocation == "조기입실"){
          return Future.value(true);
        }

        await FirebaseFirestore.instance.collection("Users").doc(SchoolName).collection("Users").doc(uid).
        update({"Date":date,"Hour":hour,"Minute":minute,"NowLocation":WifiName,"SpecialComment":""});
      }
    }
    //#endregion

    return Future.value(true);
  });
}
void callbackDispatcherWifi() async{
  await Firebase.initializeApp();

  String uid = await FirebaseAuth.instance.currentUser.uid;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String SchoolName = await prefs.getString("SchoolName") ?? "";

  var date = await int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
  var hour = await DateTime.now().hour;
  var minute = await DateTime.now().minute;

  String WifiName;
  int CheckDate;
  String NowLocation;

  if(SchoolName == ""){
    return Future.value(true);
  }
  if(!(hour>=18&&hour<=24)){
    return Future.value(true);
  }

  //#regioncheck wifi
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    WifiName = "확인불가";
  }
  else if (connectivityResult == ConnectivityResult.wifi) {
    var wifiName = await WifiInfo().getWifiName();
    switch(SchoolName){
      case "경기북과학고등학교":
        WifiName =  await GBSwifi(wifiName);
        break;

      default:
        break;
    }
  }
  else{
    WifiName = "None";
  }
  //#endregion
  //#region check my id
  if(WifiName != "None" &&  WifiName != "확인불가"){
    final snapShot = await FirebaseFirestore.instance.collection("Users").doc(SchoolName).collection("Users").doc(uid).get();
    if (snapShot == null || !snapShot.exists) {
      return Future.value(true);
    }else{
      await FirebaseFirestore.instance.collection("Users").doc(SchoolName).collection("Users").doc(uid).get().
      then((DocumentSnapshot ds){
        CheckDate = ds.get("Date");
        NowLocation = ds.get("NowLocation");
      });

      if(CheckDate == date && NowLocation == "조기입실"){
        return Future.value(true);
      }

      await FirebaseFirestore.instance.collection("Users").doc(SchoolName).collection("Users").doc(uid).
      update({"Date":date,"Hour":hour,"Minute":minute,"NowLocation":WifiName,"SpecialComment":""});
    }
  }
  //#endregion

  return Future.value(true);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // 세로 위쪽 방향 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child,
          );
        },
        title: 'checkschool',
        theme: ThemeData(
          fontFamily: "SCDream4",
          appBarTheme: AppBarTheme(
            color: Colors.white,
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}