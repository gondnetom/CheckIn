import 'package:checkschool/MainPage/PartPage/SpecialCircumstance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'PartPage/Setting.dart';

class MainPage extends StatefulWidget {
  String NetworkCheck;
  String SchoolName;
  String uid;

  MainPage(this.NetworkCheck,this.SchoolName,this.uid);

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  Stream currentStream;

  //조기입실
  Future EarlyEnter() async{
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;

    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).
    update({"Date":date,"Hour":hour,"Minute":minute,"NowLocation":"조기입실","SpecialComment":""});

    setState(() {
    });
  }
  Future EarlyEnterCancle() async{

    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).
    update({"Date":0,});

    setState(() {
    });
  }

  //출석
  Future Check() async{
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;

    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).
    update({"Date":date,"Hour":hour,"Minute":minute,"NowLocation":widget.NetworkCheck,"SpecialComment":""});

    setState(() {
    });
  }

  //특별실 신청
  var ApplyTime = Map();
  Future DeleteApply() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).
    update({"ApplyDate":0});

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).snapshots();
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");

    return StreamBuilder(
      stream: currentStream,
      builder:(context,snapshot){
        if(snapshot.hasData){
          var documents;
          documents = snapshot.data;
          ApplyTime = documents["ApplyTime"];

          if(documents["Access"]){
            return Scaffold(
                appBar: AppBar(
                  title: Text("Menu",style: TextStyle(fontSize: 30,color: Colors.black)),
                  actions: [
                    IconButton(
                      icon:Icon(CupertinoIcons.settings,color: Colors.black,),
                      onPressed: (){
                        showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => Setting(),
                        );
                      },
                    ),
                  ],
                ),
                body: ListView(
                  children: [
                    //사용자 정보
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all( Radius.circular(7), ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("출석체크: ",style: TextStyle(fontSize: 20,color: Colors.white)),
                              documents["Date"]==date ?
                              Icon(CupertinoIcons.check_mark,color: Colors.white,) : Icon(CupertinoIcons.xmark,color: Colors.white,),
                              SizedBox(width: 5,),
                              documents["Date"]==date ?
                              Text("출석위치: ${documents["NowLocation"]}",style: TextStyle(fontSize: 20,color: Colors.white))
                                  : Container(),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text("현재위치: ${widget.NetworkCheck}",style: TextStyle(fontSize: 20,color: Colors.white)),
                          SizedBox(height: 5,),
                          Text("${documents["Grade"]}${documents["Class"]}${documents["Number"]~/10==0 ? "0":""}${documents["Number"]} ${documents["Name"]}",style: TextStyle(fontSize: 20,color: Colors.white)),
                        ],
                      ),
                    ),

                    //CheckIn
                    //조기입실
                    GestureDetector(
                      onTap: (){
                        var hour = DateTime.now().hour;

                        if(!(hour>=18&&hour<=24)){
                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message:
                              "6시 이후부터 출석할 수 있습니다.",
                            ),
                          );
                          return;
                        }

                        if(documents["Date"] == date && documents["NowLocation"] == "조기입실"){
                          EarlyEnterCancle();
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
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${documents["Date"] == date && documents["NowLocation"] == "조기입실" ? "조기입실 취소":"조기입실"}",style:TextStyle(fontSize: 30)),
                            Icon(CupertinoIcons.check_mark)
                          ],
                        ),
                      ),
                    ),
                    //출석
                    GestureDetector(
                      onTap: (){
                        var hour = DateTime.now().hour;

                        if(!(hour>=18&&hour<=24)){
                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message:
                              "6시 이후부터 출석할 수 있습니다.",
                            ),
                          );
                          return;
                        }

                        if(documents["Date"] == date && documents["NowLocation"] == "조기입실"){
                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message:
                              "이미 조기입실 되었습니다.",
                            ),
                          );
                          return;
                        }

                        if(widget.NetworkCheck == "확인불가"){
                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message:
                              "학교 와이파이안에서 출석해주세요.",
                            ),
                          );
                          return;
                        }

                        Check();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all( Radius.circular(7), ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${documents["Date"] == date?"현재위치 변경":"출석하기"}",style:TextStyle(fontSize: 30)),
                            Icon(CupertinoIcons.check_mark)
                          ],
                        ),
                      ),
                    ),
                    //출석 특별한 상황
                    GestureDetector(
                      onTap: (){
                        var hour = DateTime.now().hour;

                        if(!(hour>=18&&hour<=24)){
                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message:
                              "6시 이후부터 출석할 수 있습니다.",
                            ),
                          );
                          return;
                        }

                        if(documents["Date"] == date && documents["NowLocation"] == "조기입실"){
                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message:
                              "이미 조기입실 되었습니다.",
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SpecialCircumstance(widget.SchoolName,widget.uid)),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all( Radius.circular(7), ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("특기사항",style:TextStyle(fontSize: 30)),
                            Icon(CupertinoIcons.check_mark)
                          ],
                        ),
                      ),
                    ),

                    //특별실 신청
                    /*
                !(documents["ApplyDate"]==date) ?
                GestureDetector(
                  onTap: (){
                    var hour = DateTime.now().hour;
                    if(!(hour<18)){
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message:
                          "6시 이전까지만 신청할 수 있습니다.",
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Put_In_For(widget.SchoolName,widget.uid)),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all( Radius.circular(7), ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("특별실 신청",style:TextStyle(fontSize: 30)),
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
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Room
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("특별실 신청: ${documents["ApplyRoom"]}",style: TextStyle(fontSize: 20)),
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
                              Text("1교시",style: TextStyle(fontSize: 19)),
                              Checkbox(
                                value: ApplyTime["First"],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("2교시",style: TextStyle(fontSize: 19)),
                              Checkbox(
                                value: ApplyTime["Second"],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("3교시",style: TextStyle(fontSize: 19)),
                              Checkbox(
                                value: ApplyTime["Third"],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("4교시",style:TextStyle(fontSize: 19)),
                              Checkbox(
                                value: ApplyTime["Forth"],
                              )
                            ],
                          )
                        ],
                      ),
                      //Reason
                      Text("신청 이유: ${documents["ApplyComment"]}",style: TextStyle(fontSize: 20)),
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
                          Text("승인을 대기하는 중",style: TextStyle(fontSize: 20)),
                        ],
                      ) :
                      Row(
                        children: [
                          Text("신청 결과:",style: TextStyle(fontSize: 20)),
                          SizedBox(width: 10,),
                          documents["BackCheck"] ?
                          Icon(CupertinoIcons.check_mark,color: Colors.black,):
                          Icon(CupertinoIcons.xmark,color: Colors.black,),
                        ],
                      ),

                      //Commnet
                      documents["BackComment"] != "" ?
                      Text("의견: ${documents["BackComment"]}",style: TextStyle(fontSize: 20)):Container(),
                    ],
                  ),
                ) : Container(),

                 */
                  ],
                ),
            );
          }else{
            return Scaffold(
              body: Center(child: Text("승인을 대기해주세요",style: TextStyle(fontSize: 20),),),
            );
          }
        }else{
          return Scaffold(
            body: Center(child: CupertinoActivityIndicator()),
          );
        }
      }
    );
  }
}