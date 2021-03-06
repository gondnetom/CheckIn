import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future getTimeTable(int Grade,int Class,String SchoolName) async {
  Map<String, dynamic> Data;
  var Timelist = Map();
  Timelist["ToDay"] = "";
  Timelist["Tomorrow"] = "";

  //api 호출을 위한 주소
  Uri Addr;
  http.Response response;
  String apiAddr;
  String apiKEY = "90a65d370dfd44d98f9f74bd9decdfc8";
  String ATPT_OFCDC_SC_CODE;
  String SD_SCHUL_CODE;

  int Date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");

  switch(SchoolName){
    case "경기북과학고등학교":
      ATPT_OFCDC_SC_CODE = "J10";
      SD_SCHUL_CODE = "7530851";
      break;
    default:
      return;
      break;
  }

  try {
    for(int i=0; i<2;i++){
      print(Date+i);
      apiAddr = await "https://open.neis.go.kr/hub/hisTimetable?KEY=${apiKEY}&Type=json&ATPT_OFCDC_SC_CODE=${ATPT_OFCDC_SC_CODE}&SD_SCHUL_CODE=${SD_SCHUL_CODE}&ALL_TI_YMD=${Date+i}&GRADE=${Grade}&CLASS_NM=${Class}";
      Addr = await Uri.parse(apiAddr);
      response = await http.get(Addr);// 필요 api 호출

      Data = json.decode(response.body);//받은 정보를 json형태로 decode

      if(Data.containsKey("RESULT")){

      }else{
        for(int j =0; j< Data["hisTimetable"][1]["row"].length; j++){//받은 데이터정보를 필요한 형태로 저장한다.
          Timelist["${i==0 ? "ToDay":"Tomorrow"}"] += "${j+1}. "+Data["hisTimetable"][1]["row"][j]["ITRT_CNTNT"] + "\n";
        }
      }
    }
  } catch (e) {
    print(e);
  }

  return Timelist;
}
Future getFoodList(int Grade,int Class,String SchoolName) async {
  Map<String, dynamic> Data;
  var Timelist = Map();

  //api 호출을 위한 주소
  Uri Addr;
  http.Response response;
  String apiAddr;
  String apiKEY = "90a65d370dfd44d98f9f74bd9decdfc8";
  String ATPT_OFCDC_SC_CODE;
  String SD_SCHUL_CODE;

  int Date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");

  switch(SchoolName){
    case "경기북과학고등학교":
      ATPT_OFCDC_SC_CODE = "J10";
      SD_SCHUL_CODE = "7530851";
      break;
    default:
      return;
      break;
  }

  try {
    for(int i=0; i<2;i++){
      apiAddr =
      "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=${apiKEY}&Type=json&ATPT_OFCDC_SC_CODE=${ATPT_OFCDC_SC_CODE}&SD_SCHUL_CODE=${SD_SCHUL_CODE}&MLSV_YMD=${Date}";
      Addr = Uri.parse(apiAddr);
      response = await http.get(Addr);//필요 api 호출
      Data = json.decode(response.body);//받은 정보를 json형태로 decode
      //받은 데이터정보를 필요한 형태로 저장한다.
      Timelist[0] = Data["mealServiceDietInfo"][1]["row"][0]["DDISH_NM"].toString().
      replaceAll("<br/>","\n").replaceAll("*","").replaceAll("\$","").replaceAll(".","").replaceAll(RegExp(r'[0-9]'),"");
      Timelist[1] = Data["mealServiceDietInfo"][1]["row"][1]["DDISH_NM"].toString().
      replaceAll("<br/>","\n").replaceAll("*","").replaceAll("\$","").replaceAll(".","").replaceAll(RegExp(r'[0-9]'),"");
      Timelist[2] = Data["mealServiceDietInfo"][1]["row"][2]["DDISH_NM"].toString().
      replaceAll("<br/>","\n").replaceAll("*","").replaceAll("\$","").replaceAll(".","").replaceAll(RegExp(r'[0-9]'),"");
    }
  } catch (e) {
    print(e);
  }

  return Timelist;
}

class SecondPage extends StatefulWidget {
  int Grade;
  int Class;
  String SchoolName;
  String uid;

  SecondPage(this.Grade,this.Class,this.SchoolName,this.uid);

  @override
  _SecondPageState createState() => _SecondPageState();
}
class _SecondPageState extends State<SecondPage> with AutomaticKeepAliveClientMixin<SecondPage>{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        /*
        FutureBuilder(
          future: getTimeTable(widget.Grade, widget.Class, widget.SchoolName),
          builder: (context,snapshot){
            if(snapshot.hasData){
              var documents;
              documents = snapshot.data;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                    constraints: BoxConstraints(minHeight: 250,minWidth: 250),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all( Radius.circular(7), ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ToDay",style: TextStyle(fontSize: 25,color: Colors.white)),
                        SizedBox(
                          height: 10,
                        ),
                        documents["ToDay"] == null ? Text("시간표 정보 없음",style: TextStyle(fontSize: 20,color: Colors.white)):
                        Text("${documents["ToDay"]}",style: TextStyle(fontSize: 20,color: Colors.white)),
                      ],
                    ),
                  ),),
                  Expanded(child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                    constraints: BoxConstraints(minHeight: 250,minWidth: 250),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all( Radius.circular(7), ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tomorrow",style: TextStyle(fontSize: 25,color: Colors.white)),
                        SizedBox(
                          height: 10,
                        ),
                        documents["Tomorrow"] == null ? Text("시간표 정보 없음",style: TextStyle(fontSize: 20,color: Colors.white)):
                        Text("${documents["Tomorrow"]}",style: TextStyle(fontSize: 20,color: Colors.white)),
                      ],
                    ),
                  ),),
                ],
              );
            }else{
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all( Radius.circular(7), ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ToDay",style: TextStyle(fontSize: 25,color: Colors.white)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white))
                      ],
                    ),
                  ),),
                  Expanded(child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all( Radius.circular(7), ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tomorrow",style: TextStyle(fontSize: 25,color: Colors.white)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text("",style: TextStyle(fontSize: 20,color: Colors.white))
                      ],
                    ),
                  ),),
                ],
              );
            }
          }
        ),
         */
        FutureBuilder(
            future: getFoodList(widget.Grade, widget.Class,widget.SchoolName),
            builder: (context,snapshot){
              if(snapshot.hasData){
                var documents;
                documents = snapshot.data;
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        documents[0] == null ?
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          constraints: BoxConstraints(minHeight: 250,minWidth: 250),
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all( Radius.circular(7),)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "조식",
                                style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "급식 정보 없음",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ):
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          constraints: BoxConstraints(minHeight: 250),
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all( Radius.circular(7),)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "조식",
                                style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                documents[0],
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        documents[1] == null ?
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          constraints: BoxConstraints(minHeight: 250,minWidth: 250),
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all( Radius.circular(7),)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "중식",
                                style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "급식 정보 없음",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ):
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          constraints: BoxConstraints(minHeight: 250),
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all( Radius.circular(7),)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "중식",
                                style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                documents[1],
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        documents[2] == null ?
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          constraints: BoxConstraints(minHeight: 250,minWidth: 250),
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all( Radius.circular(7),)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "석식",
                                style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "급식 정보 없음",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ):
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          constraints: BoxConstraints(minHeight: 250),
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all( Radius.circular(7),)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "석식",
                                style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                documents[2],
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }else{
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(minHeight: 250,minWidth: 250),
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all( Radius.circular(7),)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "조식",
                                style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "로딩중...",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(minHeight: 250,minWidth: 250),
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all( Radius.circular(7),)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "중식",
                                style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "로딩중...",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(minHeight: 250,minWidth: 250),
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all( Radius.circular(7),)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "석식",
                                style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "로딩중...",
                                style: TextStyle(fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
        ),
      ],
    );
  }
}