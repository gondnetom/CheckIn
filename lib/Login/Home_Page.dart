import 'package:checkschool/MainPage/CheckLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'SignUp.dart';
import 'google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final provider = Provider.of<GoogleSignInProvider>(context);

        if (provider.isSigningIn) {//로그인중...
          return buildLoading();
        } else if (snapshot.hasData) {//로그인이 되었다면
          return Check();
        } else {//회원가입하기
          return SignUpWidget();
        }
      },
    );
  }

  Widget buildLoading(){
    return Scaffold(
      body: Center(
        child: Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}