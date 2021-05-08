import 'package:checkschool/checkschoolsagam/List/AverageList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  String SchoolName;

  FirstPage(this.SchoolName);

  @override
  _FirstPageState createState() => _FirstPageState();
}
class _FirstPageState extends State<FirstPage> with AutomaticKeepAliveClientMixin<FirstPage> {
  var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
  Stream<QuerySnapshot> currentStream;
  List<DocumentSnapshot> documents;

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("1학년"),
    1: Text("2학년"),
    2: Text("3학년")
  };

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").
    where("Access",isEqualTo: true).where("Grade",isEqualTo: segmentedControlGroupValue+1).
    where("Date",isEqualTo:date).
    orderBy("Class").orderBy("Number").
    snapshots();

    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
          stream: currentStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              documents = snapshot.data.docs;
              return ListView.builder(
                itemCount: documents.length+1,
                itemBuilder: (context, index) {
                  if(index -1 == -1){
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
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
                    return AverageList(documents[index-1]);
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
        ),
    );
  }
}
