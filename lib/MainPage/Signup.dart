import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignUp extends StatefulWidget {
  String SchoolName;
  String uid;

  SignUp(this.SchoolName,this.uid);

  @override
  _SignUpState createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {

  Future SignUp() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).
    set({"Name":_tec2.text.toString(),"Grade":Grade,"Class":Class,"Number":Number,"Date":0,"Hour":0,"Minute":0,"NowLocation":"","DeviceId":widget.uid,
    "ApplyRoom":"","ApplySubject":"","ApplyDate":0,"ApplyHour":0,"ApplyMinute":0,"ApplyComment":"","ApplyTime":{},
      "BackCheck":false,"BackComment":"","SpecialComment":"","Access":false});
  }

  int Grade = 1;
  int Class = 1;
  int Number = 1;

  TextEditingController _tec2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Text("학번과 이름은 바꿀 수 없습니다",style:TextStyle(fontSize: 15)),
          SizedBox(height: 5,),
          Text("정확히 입력해주세요",style: TextStyle(fontSize: 15)),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.symmetric(vertical: 1,horizontal: 5),
            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(7),topRight: Radius.circular(7))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("학년"),
                    NumberPicker(
                      value: Grade,
                      minValue: 1,
                      maxValue: 5,
                      onChanged: (value) => setState(() => Grade = value),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("반"),
                    NumberPicker(
                      value: Class,
                      minValue: 1,
                      maxValue: 9,
                      onChanged: (value) => setState(() => Class = value),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("번호"),
                    NumberPicker(
                      value: Number,
                      minValue: 1,
                      maxValue: 99,
                      onChanged: (value) => setState(() => Number = value),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 1,horizontal: 5),
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(7),bottomRight: Radius.circular(7))
            ),
            child: TextField(
              controller: _tec2,
              style: TextStyle(color: Colors.black,fontSize: 20),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: Icon(Icons.account_circle_outlined,color: Colors.grey,size: 30,),
                  hintText: '이름',
                  hintStyle: TextStyle(color: Colors.grey)
              ),
              cursorColor: Colors.grey,
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              if(_tec2.text.length ==0) {
                showTopSnackBar(
                  context,
                  CustomSnackBar.error(
                    message:
                    "이름을 입력해 주세요!",
                  ),
                );
                return;
              }

              SignUp();
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
              child: Text("가입하기",style: TextStyle(fontSize: 20,color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}