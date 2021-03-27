import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'google_sign_in.dart';


class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  String SchoolName = "학교 고르기";
  List<String> DetailName = ["경기북과학고등학교",];

  Future SchoolNameSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SchoolName', SchoolName);

    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.login();
  }

  @override
  Widget build(BuildContext context){

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
                            SchoolName = "학교 고르기";
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
                          SchoolName = DetailName[value];
                        });
                      },
                      itemExtent: 32.0,
                      children: const [
                        Text("경기북과학고등학교"),
                      ],
                    )
                )
              ],
            );
          }
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/app_icon.png"),
              Text("CheckIn",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
              SizedBox(height: 60,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    SchoolName = "경기북과학고등학교";
                  });
                  showPicker();
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border:Border.all(
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${SchoolName}",style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: (){
                  if(SchoolName == "학교 고르기"){
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message:
                        "학교를 골라주세요!",
                      ),
                    );
                    return;
                  }

                  SchoolNameSet();
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border:Border.all(
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.google, color: Colors.red),
                        SizedBox(width: 5,),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    )
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
