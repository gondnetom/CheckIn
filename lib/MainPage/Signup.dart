import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  String DeviceId;
  SignUp(this.DeviceId);

  @override
  _SignUpState createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {

  Future SignUp() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.DeviceId).
    set({"Name":_tec2.text.toString(),"Number":int.parse(_tec.text.toString()),"Date":0,"Hour":0,"Minute":0,"NowLocation":"","DeviceId":widget.DeviceId});
  }

  TextEditingController _tec = TextEditingController();
  TextEditingController _tec2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("학번과 이름은 바꿀 수 없습니다",style: GoogleFonts.nanumGothicCoding(fontSize: 15)),
        SizedBox(height: 5,),
        Text("정확히 입력해주세요",style: GoogleFonts.nanumGothicCoding(fontSize: 15)),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all( Radius.circular(7), ),
            boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
              blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
          ),
          child: TextField(
            controller: _tec,
            style: TextStyle(color: Colors.black,fontSize: 20),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              prefixIcon: Icon(Icons.ballot_outlined,color: Colors.grey,size: 30,),
              hintText: '학번',
              hintStyle: TextStyle(color: Colors.grey)
            ),
            cursorColor: Colors.grey,
          ),
        ),
        SizedBox(height: 5,),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all( Radius.circular(7), ),
            boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
              blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
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
            if(_tec.text.length ==0)
              return;
            if(_tec2.text.length ==0)
              return;

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
            child: Text("가입하기",style: GoogleFonts.nanumGothicCoding(fontSize: 20,color: Colors.white)),
          ),
        ),
      ],
    );
  }
}