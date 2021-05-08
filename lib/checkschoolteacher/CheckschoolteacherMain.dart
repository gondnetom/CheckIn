import 'package:checkschool/checkschoolteacher/MainPage/SelectPage.dart';
import 'package:checkschool/checkschoolteacher/MainPage/MainPage.dart';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckschoolteacherMain extends StatefulWidget {
  String SchoolName;

  CheckschoolteacherMain(this.SchoolName);

  @override
  _CheckschoolteacherMainState createState() => _CheckschoolteacherMainState();
}
class _CheckschoolteacherMainState extends State<CheckschoolteacherMain> {
  Future Select() async{
    var list = Map();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    list["CheckSubject"] = await prefs.getString("Subject") ?? "";

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Select(),
      builder:(context,snapshot){
        if(snapshot.hasData){
          return snapshot.data["CheckSubject"] == "" ?
          SelectPage():MainPage(snapshot.data["CheckSubject"],widget.SchoolName);
        }else{
          return Center(child: CupertinoActivityIndicator());
        }
      }
    );
  }
}
