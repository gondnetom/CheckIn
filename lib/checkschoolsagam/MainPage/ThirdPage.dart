import 'package:checkschool/checkschoolsagam/List/AverageList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThirdPage extends StatefulWidget {
  String SchoolName;

  ThirdPage(this.SchoolName);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}
class _ThirdPageState extends State<ThirdPage> {
  var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
  Stream<QuerySnapshot> currentStream;
  List<DocumentSnapshot> documents;

  @override
  Widget build(BuildContext context) {
    currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").
    where("Access",isEqualTo: true).where("Date",isEqualTo:date).where("NowLocation",isEqualTo: "조기입실").
    orderBy("Hour",descending: true).orderBy("Minute",descending: true).snapshots();

    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: currentStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            documents = snapshot.data.docs;

            if(documents.length != 0){
              return ListView.builder(
                key: PageStorageKey("ThirdPage"),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return AverageList(documents[index]);
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
      ),
    );
  }
}
