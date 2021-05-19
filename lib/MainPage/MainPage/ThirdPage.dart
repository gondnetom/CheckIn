import 'package:checkschool/MainPage/PartPage/third/An_Chat_Page.dart';
import 'package:checkschool/MainPage/PartPage/third/Board/An_Board.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future getTemp() async {
  Map<String, dynamic> Data;
  String Temp;

  //api 호출을 위한 주소
  Uri Addr;
  http.Response response;
  String apiAddr;

  try {
    apiAddr = await "https://api.hangang.msub.kr/";
    Addr = await Uri.parse(apiAddr);
    response = await http.get(Addr);// 필요 api 호출

    Data = json.decode(response.body);//받은
    Temp = Data["temp"];
  } catch (e) {
    print(e);
  }

  return Temp;
}

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
        //한강수온
        FutureBuilder(
            future: getTemp(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all( Radius.circular(7), ),
                  ),
                  child: Text("한강수온: ${snapshot.data}°C",style:TextStyle(fontSize: 30)),
                );
              }else{
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all( Radius.circular(7), ),
                  ),
                  child: Text("한강수온: 로딩중...",style:TextStyle(fontSize: 30)),
                );
              }
            }
        ),
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
        //익명게시판
        GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => An_Board(widget.uid, widget.SchoolName))
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
                Text("커뮤니티",style:TextStyle(fontSize: 30)),
                Icon(CupertinoIcons.chevron_forward,size: 34,)
              ],
            ),
          ),
        ),
      ],
    );
  }
}