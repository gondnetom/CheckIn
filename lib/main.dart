import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:checkschool/MainPage/CheckLogin.dart';
import 'package:flutter/services.dart';

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

    return MaterialApp(
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
      home: Check()
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