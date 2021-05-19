import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../main.dart';

class Upload_Comment extends StatefulWidget {
  String documentsID;
  String uid;
  String SchoolName;

  Upload_Comment(this.documentsID,this.uid,this.SchoolName);

  @override
  _Upload_CommentState createState() => _Upload_CommentState();
}

class _Upload_CommentState extends State<Upload_Comment> {
  //#region Basic
  bool wait = false;

  final TextEditingController Text_textController = new TextEditingController();
  //#endregion

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Text("댓글",style: TextStyle(color:Colors.black),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.left_chevron,color:Colors.black),
          onPressed: (){
            if(wait)
              return;

            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.check_mark,color:Colors.black),
            onPressed: (){
              if(wait)
                return;

              FocusScope.of(context).requestFocus(new FocusNode());
              if(Text_textController.text.length==0){
                if(isiOS){
                  showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: new Text("내용 없음"),
                        content: new Text("내용을 입력해주세요"),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text("확인"),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )
                  );
                }
                else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("내용 없음"),
                        content: new Text("내용을 입력해주세요"),
                        actions: [
                          FlatButton(
                            child: Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }

                return;
              }

              Upload();
            },

          )
        ],
      ),

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
            child:  SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: CupertinoTextField(
                  controller: Text_textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  maxLength: 100,
                  placeholder: "댓글 내용",
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(5),
                        topRight: const Radius.circular(5),
                        bottomLeft: const Radius.circular(5),
                        bottomRight: const Radius.circular(5),
                      )
                  ),
                  style: TextStyle(fontSize: 18,),
                ),
              )
            )
        ),
      ),
    );
  }

  Future Upload() async {
    wait= true;
    EasyLoading.show(status: 'loading...',);

    var NowMilliTime = DateTime.now().millisecondsSinceEpoch;
    var NowTime = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");

    //write Post Information
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).
    collection("Posts").doc(widget.documentsID).collection("Comments").
    doc("${widget.uid}${NowMilliTime}").
    set({'Uid':widget.uid,'Report':[],
      'Text':Text_textController.text.toString(),
      'MilliTime':NowMilliTime,'Time':NowTime,});


    EasyLoading.dismiss();
    Navigator.pop(context);
  }
}
