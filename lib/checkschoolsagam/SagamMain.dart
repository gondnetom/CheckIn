import 'package:checkschool/MainPage/PartPage/Setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:checkschool/checkschoolsagam/MainPage/FirstPage.dart';
import 'package:checkschool/checkschoolsagam/MainPage/SecondPage.dart';
import 'package:checkschool/checkschoolsagam/MainPage/ThirdPage.dart';
import 'package:checkschool/checkschoolsagam/MainPage/ForthPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SagamMain extends StatefulWidget {
  String SchoolName;

  SagamMain(this.SchoolName);

  @override
  _SagamMainState createState() => _SagamMainState();
}
class _SagamMainState extends State<SagamMain> with AutomaticKeepAliveClientMixin<SagamMain> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // 탭의 수 설정
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Checking',style: TextStyle(color: Colors.black),),
          // TabBar 구현. 각 컨텐트를 호출할 탭들을 등록
          bottom: TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(text: "학생전체",icon: Icon(CupertinoIcons.list_bullet,color: Colors.black,)),
              Tab(text: "출석안함",icon: Icon(CupertinoIcons.circle,color: Colors.black)),
              Tab(text: "조기입실",icon: Icon(CupertinoIcons.moon_zzz,color: Colors.black)),
              Tab(text: "계정관련",icon: Icon(CupertinoIcons.person,color: Colors.black)),
            ],
          ),
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
        // TabVarView 구현. 각 탭에 해당하는 컨텐트 구성
        body: TabBarView(
          children: [
            FirstPage(widget.SchoolName),
            SecondPage(widget.SchoolName),
            ThirdPage(widget.SchoolName),
            ForthPage(widget.SchoolName)
          ],
        ),
      ),
    );
  }
}
