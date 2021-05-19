import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class Comment_Widget extends StatefulWidget {
  var documents;
  String PostdocumentsID;
  String uid;
  String SchoolName;

  Comment_Widget(this.documents,this.PostdocumentsID,this.uid,this.SchoolName);

  @override
  _Comment_WidgetState createState() => _Comment_WidgetState();
}
class _Comment_WidgetState extends State<Comment_Widget> {

  //삭제
  Future DeletePost() async{
    await  FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).
    collection("Posts").doc(widget.PostdocumentsID).collection("Comments").
    doc(widget.documents.id).delete();
  }
  //신고
  Future Declaration() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).
    collection("Posts").doc(widget.PostdocumentsID).collection("Comments").
    doc(widget.documents.id).update({'Report':FieldValue.arrayUnion([widget.uid])});
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        if(isiOS){
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
                actions: <Widget>[
                  widget.documents["Uid"]== widget.uid ?
                  CupertinoActionSheetAction(
                    child: const Text('삭제하기'),
                    onPressed: () {
                      Navigator.pop(context);
                      DeletePost();
                    },
                  ):
                  CupertinoActionSheetAction(
                    child: const Text('신고하기'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text('취소'),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
            ),
          );
        }
        else{
          showAdaptiveActionSheet(
            context: context,
            actions: <BottomSheetAction>[
              widget.documents["Uid"]== widget.uid ?
              BottomSheetAction(title: '삭제하기', onPressed: () {
                Navigator.pop(context);
                DeletePost();
              }):
              BottomSheetAction(title: '신고하기', onPressed: () {
                Navigator.pop(context);
              }),
            ],
            cancelAction: CancelAction(title: '취소'),// onPressed parameter is optional by default will dismiss the ActionSheet
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        decoration: BoxDecoration(
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.documents["Text"]}",style: TextStyle(color: Colors.black,fontSize: 25),),
            Text("${widget.documents["Uid"].toString().substring(0,5)}  ${widget.documents["Time"]}",style: TextStyle(color: Colors.black,fontSize: 10),),
          ],
        ),
      ),
    );
  }
}
