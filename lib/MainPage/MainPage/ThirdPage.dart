import 'package:checkschool/MainPage/PartPage/An_Chat_Page.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThirdPage extends StatefulWidget {
  String SchoolName;
  String uid;

  ThirdPage(this.SchoolName,this.uid);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}
class _ThirdPageState extends State<ThirdPage> with AutomaticKeepAliveClientMixin<ThirdPage>{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        //익명채팅
        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => An_Chat_Page(widget.uid,widget.SchoolName))
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
                Text("익명채팅",style:TextStyle(fontSize: 30)),
                Icon(CupertinoIcons.chevron_forward,size: 34,)
              ],
            ),
          ),
        ),
      ],
    );
  }
}