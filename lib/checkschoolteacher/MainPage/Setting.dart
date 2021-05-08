import 'package:checkschool/checkschoolteacher/CheckschoolteacherMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String Subject = "과목 고르기";

  List<String> DetailSubject = ["물리","화학","생명","지구과학","정보"];
  showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xff999999),
                      width: 0.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('취소'),
                      onPressed: () {
                        setState(() {
                          Subject = "과목 고르기";
                        });
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                    ),
                    CupertinoButton(
                      child: Text('확인'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  height: 320.0,
                  color: Color(0xfff7f7f7),
                  child:CupertinoPicker(
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        Subject = DetailSubject[value];
                      });
                    },
                    itemExtent: 32.0,
                    children: const [
                      Text("물리"),
                      Text("화학"),
                      Text("생명"),
                      Text("지구과학"),
                      Text("정보"),
                    ],
                  )
              )
            ],
          );
        }
    );
  }

  Future SelectSubject() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("Subject", Subject);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Setting",style: TextStyle(color: Colors.black),),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(CupertinoIcons.left_chevron,color: Colors.black,),
          ),
        ),
        body: ListView(
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  Subject = "물리";
                });
                showPicker();
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 15,horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all( Radius.circular(7), ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${Subject}",style: TextStyle(fontSize: 30)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                if(Subject == "과목 고르기"){
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message:
                      "과목을 골라주세요.",
                    ),
                  );
                  return;
                }

                SelectSubject();
                Navigator.pop(context);
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all( Radius.circular(7), ),
                    boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
                      blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
                  ),
                  child: Center(
                    child: Text("변경하기",style: TextStyle(fontSize: 20,color: Colors.white)),
                  )
              ),
            ),
          ],
        )
    );
  }
}