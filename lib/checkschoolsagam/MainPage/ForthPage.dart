import 'package:checkschool/checkschoolsagam/List/DeleteList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForthPage extends StatefulWidget {
  String SchoolName;

  ForthPage(this.SchoolName);

  @override
  _ForthPageState createState() => _ForthPageState();
}
class _ForthPageState extends State<ForthPage> {
  Stream<QuerySnapshot> currentStream;
  List<DocumentSnapshot> documents;

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("계정승인"),
    1: Text("계정삭제")
  };

  @override
  Widget build(BuildContext context) {
    if(segmentedControlGroupValue == 0){
      currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").
      where("Access",isEqualTo: false).orderBy("Grade").orderBy("Class").orderBy("Number").snapshots();
    }else if(segmentedControlGroupValue == 1){
      currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").
      where("Access",isEqualTo: true).orderBy("Grade").orderBy("Class").orderBy("Number").snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: currentStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          documents = snapshot.data.docs;
          return ListView.builder(
            key: PageStorageKey("ForthPage"),
            itemCount: documents.length+2,
            itemBuilder: (context, index) {
              if(index -2 == -2){
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  child: CupertinoSlidingSegmentedControl(
                      groupValue: segmentedControlGroupValue,
                      children: myTabs,
                      onValueChanged: (i) {
                        setState(() {
                          segmentedControlGroupValue = i;
                        });
                      }
                  ),
                );
              }
              else if(index -2 == -1){
                return Container(
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all( Radius.circular(7), ),
                    ),
                    child: segmentedControlGroupValue == 0 ?
                    Text("대기인원: ${documents.length}명",style: TextStyle(fontSize: 20)):
                    Text("현재인원: ${documents.length}명",style: TextStyle(fontSize: 20))
                );
              }
              else{
                return DeleteList(widget.SchoolName,documents[index-2]);
              }
            },
          );
        }else{
          return Container(
            decoration: BoxDecoration(
            ),
            child: Center(child: CupertinoActivityIndicator(),),
          );
        }
      },
    );
  }
}
