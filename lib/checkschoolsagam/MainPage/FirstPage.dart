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

  int segmentedControlGroupValueban = 0;
  final Map<int, Widget> myTabsGBS = const <int, Widget>{
    0: Text("1"),
    1: Text("2"),
    2: Text("3"),
    3: Text("4"),
    4: Text("5")
  };

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").
    where("Access",isEqualTo: true).
    where("Grade",isEqualTo: segmentedControlGroupValue+1).
    where("Class",isEqualTo: segmentedControlGroupValueban+1).
    where("Date",isEqualTo:date).
    orderBy("Number").
    snapshots();

    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
          stream: currentStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              documents = snapshot.data.docs;
              return ListView.builder(
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
                    switch(widget.SchoolName){
                      case "경기북과학고등학교":
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          child: CupertinoSlidingSegmentedControl(
                              groupValue: segmentedControlGroupValueban,
                              children: myTabsGBS,
                              onValueChanged: (i) {
                                setState(() {
                                  segmentedControlGroupValueban = i;
                                });
                              }
                          ),
                        );
                      default:
                        return Container();
                        break;
                    }
                  }
                  else{
                    return AverageList(documents[index-2]);
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
