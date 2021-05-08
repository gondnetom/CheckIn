import 'package:checkschool/checkschoolteacher/List/RequestList.dart';
import 'package:checkschool/checkschoolteacher/MainPage/Setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  String Subject;
  String SchoolName;
  
  MainPage(this.Subject,this.SchoolName);

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  Stream<QuerySnapshot> currentStream;
  List<DocumentSnapshot> documents;

  @override
  Widget build(BuildContext context) {
    var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").
    where("ApplySubject",isEqualTo: widget.Subject).where("ApplyDate",isEqualTo: date).orderBy("ApplyHour",descending: true).
    orderBy("ApplyMinute",descending: true).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.Subject}",style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Setting())
              );
            },
            icon: Icon(CupertinoIcons.settings,color: Colors.black,),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: currentStream,
        builder: (context,snapshot){
          if (snapshot.hasData) {
            documents = snapshot.data.docs;

            if(documents.length != 0){
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return RequestList(documents[index],documents[index].id,widget.SchoolName);
                },
              );
            }else{
              return Center(child: Text("Not Found",style: TextStyle(color:Colors.black),),);
            }
          }else{
            return Container(
              decoration: BoxDecoration(
              ),
              child: Center(child: CupertinoActivityIndicator(),),
            );
          }
        },
      )
    );
  }
}
