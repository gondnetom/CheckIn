import 'package:checkschool/checkschoolsagam/SagamMain.dart';
import 'package:checkschool/checkschoolteacher/CheckschoolteacherMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:checkschool/MainPage/MainPage/FirstPage.dart';
import 'package:checkschool/MainPage/MainPage/SecondPage.dart';
import 'package:checkschool/MainPage/MainPage/ThirdPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'PartPage/Setting.dart';

class MainPage extends StatefulWidget {
  String NetworkCheck;
  String SchoolName;
  String uid;

  MainPage(this.NetworkCheck,this.SchoolName,this.uid);

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin<MainPage> {
  @override
  bool get wantKeepAlive => true;

  var documents;
  Stream currentStream;

  Widget CheckFirstPage(){
    if(widget.NetworkCheck != "NotLocationData"){
      return FirstPage(documents,widget.SchoolName,widget.uid,widget.NetworkCheck);
    }else{
      return Center(child: Text("위치정보를 허용해주세요.",style: TextStyle(fontSize: 20,color: Colors.black),));
    }
  }

  @override
  Widget build(BuildContext context) {
    currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.uid).snapshots();

    return StreamBuilder(
      stream: currentStream,
      builder:(context,snapshot){
        if(snapshot.hasData){
          documents = snapshot.data;
          if(documents["Access"]){
            if(documents["Grade"]==4){
              return SagamMain(widget.SchoolName);
            }
            else if(documents["Grade"]==5){
              return CheckschoolteacherMain(widget.SchoolName);
            }
            else{
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text("CheckIn",style: TextStyle(fontSize: 30,color: Colors.black)),
                    centerTitle: false,
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
                  bottomNavigationBar: TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(CupertinoIcons.house),
                        text: 'home',
                      ),
                      Tab(
                        icon: Icon(CupertinoIcons.calendar_today),
                        text: 'Daily',
                      ),
                    ],
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                  ),
                  body: TabBarView(
                    children: [
                      CheckFirstPage(),
                      SecondPage(documents["Grade"],documents["Class"],widget.SchoolName,widget.uid),
                    ],
                  ),
                ),
              );
            }
          }
          else{
            return Scaffold(
              body: Center(child: Text("승인을 대기해주세요",style: TextStyle(fontSize: 20),),),
            );
          }
        }
        else{
          return Scaffold(
            body: Center(child: CupertinoActivityIndicator()),
          );
        }
      }
    );
  }
}