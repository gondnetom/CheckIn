import 'package:checkschool/checkschoolsagam/List/AverageList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SecondPage extends StatefulWidget {
  String SchoolName;

  SecondPage(this.SchoolName);

  @override
  _SecondPageState createState() => _SecondPageState();
}
class _SecondPageState extends State<SecondPage> with AutomaticKeepAliveClientMixin<SecondPage> {
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

  String NameList;
  Future CopyName() async{
    NameList = "";
    for(int i = 0; i <documents.length; i++){
      NameList += documents[i]["Name"]+" ";
    }
    Clipboard.setData(ClipboardData(text: NameList));
  }

  @override
  Widget build(BuildContext context) {
    currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").
    where("Access",isEqualTo: true).where("Grade",isEqualTo: segmentedControlGroupValue+1).
    where("Date",isNotEqualTo:date).orderBy("Date",descending: true).
    orderBy("Class").orderBy("Number").
    snapshots();

    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: currentStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            documents = snapshot.data.docs;

            return ListView.builder(
              key: PageStorageKey("SecondPage"),
              itemCount: documents.length+1,
              itemBuilder: (context, index) {
                if(index -1 == -1){
                  return Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          child:CupertinoSlidingSegmentedControl(
                              groupValue: segmentedControlGroupValue,
                              children: myTabs,
                              onValueChanged: (i) {
                                setState(() {
                                  segmentedControlGroupValue = i;
                                });
                              }
                          ),
                      ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.all( Radius.circular(7), ),
                          ),
                          child: Text("Copy",style: TextStyle(fontSize: 20)),
                        ),
                        onTap: (){
                          CopyName();
                          showTopSnackBar(
                            context,
                            CustomSnackBar.success(
                              message:
                              "복사되었습니다.",
                            ),
                          );
                        },
                      )
                    ],
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
