import 'package:checkschool/MainPage/PartPage/third/Board/Board_Widget.dart';
import 'package:checkschool/MainPage/PartPage/third/Board/Upload_Board.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class An_Board extends StatefulWidget {
  String uid;
  String SchoolName;

  An_Board(this.uid,this.SchoolName);

  @override
  _An_BoardState createState() => _An_BoardState();
}
class _An_BoardState extends State<An_Board> {
  Stream<QuerySnapshot> currentStream;
  List<DocumentSnapshot> documents;

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("인기"),
    1: Text("실시간"),
  };

  @override
  Widget build(BuildContext context) {
    if(segmentedControlGroupValue == 0){
      currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Posts").
      orderBy("Time",descending: true).
      orderBy("LikeCnt",descending: true).limit(50).
      snapshots();
    }
    else{
      currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Posts").
      orderBy("MilliTime",descending: true).limit(100).
      snapshots();
    }

    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon:Icon(CupertinoIcons.left_chevron,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon:Icon(CupertinoIcons.plus,color: Colors.black,),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadPost(widget.uid,widget.SchoolName))
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: currentStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            documents = snapshot.data.docs;
            return ListView.separated(
              itemCount: documents.length+1,
              itemBuilder: (context, index) {
                if(index-1 == -1){
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
                }else{
                  return Board_Widget(widget.uid,widget.SchoolName,documents[index-1]);
                }
              },
              separatorBuilder : (context, index) {
                return Divider(
                  color: Color(0xff4d4d4d),
                  height: 5,
                  indent: 10,
                  endIndent: 10,
                );
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
      ),
    );
  }
}
