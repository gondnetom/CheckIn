import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:checkschool/MainPage/PartPage/third/Board/Comment_Widget.dart';
import 'package:checkschool/MainPage/PartPage/third/Board/Upload_Board.dart';
import 'package:checkschool/MainPage/PartPage/third/Board/Upload_Comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class DetailBaord extends StatefulWidget {
  String uid;
  String SchoolName;
  var documents;

  DetailBaord(this.uid,this.SchoolName,this.documents);

  @override
  _DetailBaordState createState() => _DetailBaordState();
}

class _DetailBaordState extends State<DetailBaord> {
  Stream<QuerySnapshot> currentStream;
  List<DocumentSnapshot> documents;

  @override
  initState() {
    likecheck = widget.documents["Like"].contains(widget.uid);
  }

  //삭제
  Future DeletePost() async{
    if(widget.documents["Image"] != ""){
      var photoRef = await FirebaseStorage.instance.refFromURL(widget.documents["Image"]);
      await photoRef.delete();
    }

    await  FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).
    collection("Posts").doc(widget.documents.id).delete();

    Navigator.pop(context);
  }
  //like 버튼 구현
  bool likecheck;
  Future PressLike() async{
    if(!likecheck){
      //like
      await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).
      collection("Posts").doc(widget.documents.id).update({'Like':FieldValue.arrayUnion([widget.uid]),'LikeCnt':FieldValue.increment(1)});
      setState(() {
        likecheck = true;
      });
    }else{
      await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).
      collection("Posts").doc(widget.documents.id).update({'Like':FieldValue.arrayRemove([widget.uid]),'LikeCnt':FieldValue.increment(-1)});
      setState(() {
        likecheck = false;
      });
    }
  }
  //신고
  Future Declaration() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).
    collection("Posts").doc(widget.documents.id).update({'Report':FieldValue.arrayUnion([widget.uid])});
  }

  @override
  Widget build(BuildContext context) {
    currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Posts").
    doc(widget.documents.id).collection("Comments").orderBy("MilliTime").limit(100).
    snapshots();

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
            icon:Icon(CupertinoIcons.ellipses_bubble,color:Color(0xff4d4d4d)),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Upload_Comment(widget.documents.id, widget.uid, widget.SchoolName))
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
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      Text("${widget.documents["Title"]}",style: TextStyle(color: Colors.black,fontSize: 30),),
                      Text("${widget.documents["Uid"]==widget.uid ? "나":widget.documents["Uid"].toString().substring(0,5)}  ${widget.documents["Time"]}",style: TextStyle(color: Colors.black,fontSize: 10),),
                      Divider(
                        color: Color(0xff4d4d4d),
                        height: 10,
                      ),

                      //image
                      widget.documents["Image"] != ""?
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            color:Colors.grey.shade300,
                          ),
                          child: Image.network(widget.documents["Image"],fit: BoxFit.cover,),
                        ),
                      ):
                      Container(),
                      SizedBox(height: 5,),

                      //text
                      Text("${widget.documents["Text"]}",style: TextStyle(color: Colors.black,fontSize: 20),),

                      //like
                      Row(
                        children: [
                          //likebutton
                          IconButton(
                              icon: Icon(
                                  likecheck?
                                  CupertinoIcons.heart_solid :
                                  CupertinoIcons.heart,
                                  size: 20,
                                  color:
                                  likecheck?
                                  Colors.pink:
                                  (Color(0xff4d4d4d))
                              ),
                              onPressed: (){
                                PressLike();
                              }
                          ),
                          IconButton(
                            icon:Icon(CupertinoIcons.ellipsis_vertical,color:Color(0xff4d4d4d)),
                            onPressed: (){
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
                          ),
                        ],
                      ),
                      Divider(
                        color: Color(0xff4d4d4d),
                        height: 10,
                      ),

                      Text("댓글 ${documents.length}개",style: TextStyle(color: Colors.black,fontSize: 15),),
                    ],
                  ),
                );
              }else{
                return Comment_Widget(documents[index-1],widget.documents.id,widget.uid,widget.SchoolName);
              }
            },
            separatorBuilder : (context, index) {
              return Divider(
                color: Color(0xff4d4d4d),
                height: 5,
                indent: 5,
                endIndent: 5,
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

