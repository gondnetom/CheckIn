import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SpecialCircumstance extends StatefulWidget {
  String SchoolName;
  String uid;
  SpecialCircumstance(this.SchoolName,this.uid);

  @override
  _SpecialCircumstanceState createState() => _SpecialCircumstanceState();
}
class _SpecialCircumstanceState extends State<SpecialCircumstance> {
  TextEditingController _tec = TextEditingController();
  TextEditingController _tec2 = TextEditingController();

  Future CheckSpecial() async{
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;

    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).
    update({"Date":date,"Hour":hour,"Minute":minute,"NowLocation":_tec.text,"SpecialComment":_tec2.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading:IconButton(
            icon:Icon(CupertinoIcons.left_chevron,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 10,),
            Text("와이파이가 없는 장소에서 활동시",style: TextStyle(fontSize: 15)),
            SizedBox(height: 5,),
            Text("그 장소와 이유를 적어주세요", style: TextStyle(fontSize: 15)),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(vertical: 1,horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(7),topRight: Radius.circular(7))
              ),
              child: TextField(
                controller: _tec,
                style: TextStyle(color: Colors.black,fontSize: 20),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '장소',
                    hintStyle: TextStyle(color: Colors.grey)
                ),
                cursorColor: Colors.grey,
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
                maxLines: 2,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '이유',
                    hintStyle: TextStyle(color: Colors.grey)
                ),
                cursorColor: Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: (){
                if(_tec.text == "조기입실"){
                  _tec2.text = "잠이나 자!!!!";
                  return;
                }

                if(_tec.text == ""){
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message:
                      "위치를 입력해주세요.",
                    ),
                  );
                  return;
                }
                if(_tec2.text == ""){
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message:
                      "이유를 입력해주세요.",
                    ),
                  );
                  return;
                }

                CheckSpecial();
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
                    child: Text("출석하기",style: GoogleFonts.nanumGothicCoding(fontSize: 20,color: Colors.white)),
                  )
              ),
            ),
          ],
        )
    );
  }
}