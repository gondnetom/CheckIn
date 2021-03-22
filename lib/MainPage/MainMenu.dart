import 'package:checkschool/MainPage/Put_in_for.dart';
import 'package:checkschool/MainPage/SpecialCircumstance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MainPage extends StatefulWidget {
  String NetworkCheck;
  String DeviceId;

  MainPage(this.NetworkCheck,this.DeviceId);

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  Stream currentStream;

  List<String> ClassName = ["자습실, 교실","물리실1","물리실2","화학실1","화학실2",
    "생명실1","생명실2","지구과학실1","지구과학실2","천문대","도서실","음악실",
    "NoteStation2","컴퓨터실1","컴퓨터실2"];

  String NowRoom = "자습실";
  List<String> DetailName = ["자습실","201호실","202호실","203호실",
    "204호실","205호실","301호실","302호실","303호실","304호실","305호실",
    "401호실","402호실","403호실","404호실","405호실","501호실","502호실",
    "503호실","504호실","505호실"];

  var ApplyTime = Map();

  Future EarlyEnter() async{
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;

    await FirebaseFirestore.instance.collection("Users").doc(widget.DeviceId).
    update({"Date":date,"Hour":hour,"Minute":minute,"NowLocation":"조기입실","SpecialComment":""});

    setState(() {
    });
  }
  Future Check() async{
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;

    await FirebaseFirestore.instance.collection("Users").doc(widget.DeviceId).
    update({"Date":date,"Hour":hour,"Minute":minute,"NowLocation":widget.NetworkCheck,"SpecialComment":""});

    setState(() {
    });
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
                      CheckDetail(NowRoom);
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
                      NowRoom= DetailName[value];
                    });
                  },
                  itemExtent: 32.0,
                  children: const [
                    Text("자습실"),
                    Text("201호실"),
                    Text("202호실"),
                    Text("203호실"),
                    Text("204호실"),
                    Text("205호실"),
                    Text("301호실"),
                    Text("302호실"),
                    Text("303호실"),
                    Text("304호실"),
                    Text("305호실"),
                    Text("401호실"),
                    Text("402호실"),
                    Text("403호실"),
                    Text("404호실"),
                    Text("405호실"),
                    Text("501호실"),
                    Text("502호실"),
                    Text("503호실"),
                    Text("504호실"),
                    Text("505호실"),
                  ],
                )
            )
          ],
        );
      });
  }
  Future CheckDetail(String RoomName) async{
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;

    await FirebaseFirestore.instance.collection("Users").doc(widget.DeviceId).
    update({"Date":date,"Hour":hour,"Minute":minute,"NowLocation":RoomName,"SpecialComment":""});

    setState(() {
    });
  }

  Future DeleteApply() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.DeviceId).
    update({"ApplyDate":0});

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.DeviceId).snapshots();
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");

    return StreamBuilder(
      stream: currentStream,
      builder:(context,snapshot){
        if(snapshot.hasData){
          var documents;
          documents = snapshot.data;
          ApplyTime = documents["ApplyTime"];
          print("asd");
          return ListView(
            children: [
              //사용자 정보
              Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all( Radius.circular(7), ),
                    boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
                      blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
                  ),
                  child: Row(
                    children: [
                      Text("출석체크: ",style: GoogleFonts.nanumGothicCoding(fontSize: 20)),
                      documents["Date"]==date ?
                      Icon(CupertinoIcons.check_mark) : Icon(CupertinoIcons.xmark),
                      SizedBox(width: 5,),
                      documents["Date"]==date ?
                      Text("현재위치:${documents["NowLocation"]}",style: GoogleFonts.nanumGothicCoding(fontSize: 20))
                      : Container(),
                    ],
                  )
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all( Radius.circular(7), ),
                  boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
                    blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("현재위치: ${widget.NetworkCheck}",style: GoogleFonts.nanumGothicCoding(fontSize: 20)),
                    SizedBox(height: 5,),
                    Text("${documents["Number"]}",style: GoogleFonts.nanumGothicCoding(fontSize: 20)),
                    SizedBox(height: 5,),
                    Text("${documents["Name"]}",style: GoogleFonts.nanumGothicCoding(fontSize: 30)),
                  ],
                ),
              ),

              //CheckIn
              documents["Date"] != date||(documents["Date"] == date && documents["NowLocation"] != "조기입실") ?
              GestureDetector(
                onTap: (){
                  var hour = DateTime.now().hour;
                  print(hour);
                  if(!(hour>=18&&hour<=24)){
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message:
                        "6시 이후부터 출석할 수 있습니다!",
                      ),
                    );
                    return;
                  }

                  EarlyEnter();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all( Radius.circular(7), ),
                    boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
                      blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("조기입실",style: GoogleFonts.nanumGothicCoding(fontSize: 30)),
                      Icon(CupertinoIcons.check_mark)
                    ],
                  ),
                ),
              ) : Container(),
              documents["Date"] != date||(documents["Date"] == date && documents["NowLocation"] != "조기입실")  ?
              GestureDetector(
                onTap: (){
                  var hour = DateTime.now().hour;
                  print(hour);
                  if(!(hour>=18&&hour<=24)){
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message:
                        "6시 이후부터 출석할 수 있습니다!",
                      ),
                    );
                    return;
                  }
                  if(!ClassName.contains(widget.NetworkCheck)){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SpecialCircumstance(widget.DeviceId)),
                    );
                    return;
                  }

                  if(widget.NetworkCheck!= "자습실, 교실"){
                    Check();
                  }
                  else{
                    setState(() {
                      NowRoom = "자습실";
                    });
                    showPicker();
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all( Radius.circular(7), ),
                    boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
                      blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${documents["Date"] == date?"현재위치 변경":"출석하기"}",style: GoogleFonts.nanumGothicCoding(fontSize: 30)),
                      Icon(CupertinoIcons.check_mark)
                    ],
                  ),
                ),
              ) : Container(),

              //특별실 신청
              !(documents["ApplyDate"]==date) ?
              GestureDetector(
                onTap: (){
                  var hour = DateTime.now().hour;
                  if(!(hour<12)){
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message:
                        "12시 이전까지만 신청할 수 있습니다!",
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Put_In_For(widget.DeviceId)),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all( Radius.circular(7), ),
                    boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
                      blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("특별실 신청",style: GoogleFonts.nanumGothicCoding(fontSize: 30)),
                      Icon(CupertinoIcons.right_chevron)
                    ],
                  ),
                ),
              ) : Container(),
              documents["ApplyDate"]==date ?
              Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all( Radius.circular(7), ),
                  boxShadow: [ BoxShadow( color: Colors.grey[500], offset: Offset(4.0, 4.0),
                    blurRadius: 15.0, spreadRadius: 1.0, ), BoxShadow( color: Colors.white, offset: Offset(-4.0, -4.0), blurRadius: 15.0, spreadRadius: 1.0, ), ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Room
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("특별실 신청: ${documents["ApplyRoom"]}",style: GoogleFonts.nanumGothicCoding(fontSize: 20)),
                        documents["BackComment"] == "" ?
                        GestureDetector(
                          onTap: (){
                            DeleteApply();
                          },
                          child: Icon(CupertinoIcons.delete,color: Colors.black,),
                        ):Container()
                      ],
                    ),
                    SizedBox(height: 10,),
                    //Check TIme
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text("1교시",style: GoogleFonts.nanumGothicCoding(fontSize: 19)),
                            Checkbox(
                              value: ApplyTime["First"],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text("2교시",style: GoogleFonts.nanumGothicCoding(fontSize: 19)),
                            Checkbox(
                              value: ApplyTime["Second"],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text("3교시",style: GoogleFonts.nanumGothicCoding(fontSize: 19)),
                            Checkbox(
                              value: ApplyTime["Third"],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text("4교시",style: GoogleFonts.nanumGothicCoding(fontSize: 19)),
                            Checkbox(
                              value: ApplyTime["Forth"],
                            )
                          ],
                        )
                      ],
                    ),
                    //Reason
                    Text("신청 이유: ${documents["ApplyComment"]}",style: GoogleFonts.nanumGothicCoding(fontSize: 20)),
                    Divider(
                        height: 20,
                        thickness: 3,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.grey
                    ),

                    //result
                    documents["BackComment"] == "" ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoActivityIndicator(),
                        SizedBox(width: 10,),
                        Text("승인을 대기하는 중",style: GoogleFonts.nanumGothicCoding(fontSize: 20)),
                      ],
                    ) :
                    Row(
                      children: [
                        Text("신청 결과:",style: GoogleFonts.nanumGothicCoding(fontSize: 20)),
                        SizedBox(width: 10,),
                        documents["BackCheck"] ?
                        Icon(CupertinoIcons.check_mark,color: Colors.black,):
                        Icon(CupertinoIcons.xmark,color: Colors.black,),
                      ],
                    ),

                    //Commnet
                    documents["BackComment"] != "" ?
                    Text("의견: ${documents["BackComment"]}",style: GoogleFonts.nanumGothicCoding(fontSize: 20)):Container(),
                  ],
                ),
              ) : Container(),
            ],
          );
        }else{
          return Center(child: CupertinoActivityIndicator());
        }
      }
    );
  }
}