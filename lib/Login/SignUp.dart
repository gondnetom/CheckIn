import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future Googlelogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SchoolName', SchoolName);

    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.login();
  }
  Future Applelogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('SchoolName', SchoolName);

    // 애플 로그인은 IOS 13부터 지원한다
    bool isAvailable = await AppleSignIn.isAvailable();
    if (!isAvailable) {
      return null;
    }

    AuthorizationResult result;

    // 로그인 요청
    try {
      result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
    } catch (e) {
      print(e);
      return null;
    }

    switch (result.status) {
    // 성공
      case AuthorizationStatus.authorized:
        final oAuthProvider = OAuthProvider('apple.com');
        final oAuthCredential = oAuthProvider.credential(
          idToken: String.fromCharCodes(result.credential.identityToken),
          accessToken:
          String.fromCharCodes(result.credential.authorizationCode),
        );

        // 파이어베이스 인증
        try {
          UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
          return userCredential;
        } catch (e) {
          return null;
        }
        break;

    // 에러
      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error.localizedDescription}");
        break;

    // 유저가 취소한 경우
      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }
    return null;
  }

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

  @override
  Widget build(BuildContext context){

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

                  Googlelogin();
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
              ),
              /*
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

                  Applelogin();
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.apple,color: Colors.white),
                        SizedBox(width: 5,),
                        Text(
                          'Sign in with Apple',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                        ),
                      ],
                    )
                ),
              ),

               */
            ],
          )
        ],
      ),
    );
  }
}
