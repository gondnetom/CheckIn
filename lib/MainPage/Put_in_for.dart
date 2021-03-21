import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Put_In_For extends StatefulWidget {
  String DeviceId;

  Put_In_For(this.DeviceId);

  @override
  _Put_In_ForState createState() => _Put_In_ForState();
}
class _Put_In_ForState extends State<Put_In_For> {
  String RoomName = "특별실 고르기";

  List<String> DetailName = ["물리실1","물리실2","화학실1","화학실2",
    "생명실1","생명실2","지구과학실1","지구과학실2","천문대","컴퓨터실1","컴퓨터실2"];
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
                        RoomName = "특별실 고르기";
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
                      RoomName = DetailName[value];
                    });
                  },
                  itemExtent: 32.0,
                  children: const [
                    Text("물리실1"),
                    Text("물리실2"),
                    Text("화학실1"),
                    Text("화학실2"),
                    Text("생명실1"),
                    Text("생명실2"),
                    Text("지구과학실1"),
                    Text("지구과학실2"),
                    Text("천문대"),
                    Text("컴퓨터실1"),
                    Text("컴퓨터실2"),
                  ],
                )
            )
          ],
        );
      }
    );
  }

  TextEditingController _tec = TextEditingController();

  bool FirstClass = false;
  bool SecondClass = false;
  bool ThirdClass = false;
  bool ForthClass = false;

  Future ApplyRoom() async{
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;
    String Subject;

    switch(RoomName){
      case "물리실1":
      case "물리실2":
        Subject = "물리";
        break;

      case "화학실1":
      case "화학실2":
        Subject = "화학";
        break;

      case "생물실1":
      case "생물실2":
        Subject = "생물";
        break;

      case "지구과학실1":
      case "지구과학실2":
        Subject = "지구과학";
        break;

      case "컴퓨터실1":
      case "컴퓨터실2":
        Subject = "정보";
        break;

      default:
        Subject = "에러";
        break;
    }

    await FirebaseFirestore.instance.collection("Users").doc(widget.DeviceId).
    update({"ApplyRoom":RoomName,"ApplySubject":Subject,"ApplyDate":date,"ApplyHour":hour,"ApplyMinute":minute,
      "ApplyComment":_tec.text,"ApplyTime":{"First":FirstClass,"Second":SecondClass,"Third":ThirdClass,"Forth":FirstClass},
      "BackCheck":false,"BackComment":""});
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
          GestureDetector(
            onTap: (){
              setState(() {
                RoomName = "물리실1";
              });
              showPicker();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all( Radius.circular(7), ),
                boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
                  blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${RoomName}",style: GoogleFonts.nanumGothicCoding(fontSize: 30)),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            padding: EdgeInsets.fromLTRB(5, 15, 5,0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all( Radius.circular(7), ),
              boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
                blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("1교시",style: GoogleFonts.nanumGothicCoding(fontSize: 19)),
                    Checkbox(
                        value: FirstClass,
                        onChanged:(bool value){
                          setState(() {
                            FirstClass = value;
                          });
                        }
                    )
                  ],
                ),
                Column(
                  children: [
                    Text("2교시",style: GoogleFonts.nanumGothicCoding(fontSize: 19)),
                    Checkbox(
                        value: SecondClass,
                        onChanged:(bool value){
                          setState(() {
                            SecondClass = value;
                          });
                        }
                    )
                  ],
                ),
                Column(
                  children: [
                    Text("3교시",style: GoogleFonts.nanumGothicCoding(fontSize: 19)),
                    Checkbox(
                        value: ThirdClass,
                        onChanged:(bool value){
                          setState(() {
                            ThirdClass = value;
                          });
                        }
                    )
                  ],
                ),
                Column(
                  children: [
                    Text("4교시",style: GoogleFonts.nanumGothicCoding(fontSize: 19)),
                    Checkbox(
                        value: ForthClass,
                        onChanged:(bool value){
                          setState(() {
                            ForthClass = value;
                          });
                        }
                    )
                  ],
                )
              ],
            ),
          ),
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
              maxLines: 2,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: '신청 이유',
                  hintStyle: TextStyle(color: Colors.grey)
              ),
              cursorColor: Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: (){
              if(RoomName == "특별실 고르기"){
                showTopSnackBar(
                  context,
                  CustomSnackBar.error(
                    message:
                    "특별실을 골라주세요.",
                  ),
                );
                return;
              }
              if(!FirstClass && !SecondClass && !ThirdClass && !ForthClass){
                showTopSnackBar(
                  context,
                  CustomSnackBar.error(
                    message:
                    "시간대를 체크해 주세요.",
                  ),
                );
                return;
              }
              if(_tec.text.length ==0){
                showTopSnackBar(
                  context,
                  CustomSnackBar.error(
                    message:
                    "신청 이유를 입력해주세요.",
                  ),
                );
                return;
              }


              ApplyRoom();
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
                  child: Text("신청하기",style: GoogleFonts.nanumGothicCoding(fontSize: 20,color: Colors.white)),
                )
            ),
          ),
        ],
      )
    );
  }
}
