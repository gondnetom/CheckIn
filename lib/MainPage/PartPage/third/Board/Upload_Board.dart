import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:checkschool/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

//댓글 업로드
class UploadPost extends StatefulWidget {
  String uid;
  String SchoolName;
  UploadPost(this.uid,this.SchoolName);

  @override
  _UploadPostState createState() => _UploadPostState();
}
class _UploadPostState extends State<UploadPost> {
  //#region Basic
  bool wait = false;

  PickedFile PostImage;

  final TextEditingController Topic_textController = new TextEditingController();
  final TextEditingController Text_textController = new TextEditingController();
  //#endregion

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Text("포스트",style: TextStyle(color:Colors.black),),
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
                if(Topic_textController.text.length==0){
                  if(isiOS){
                    showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                          title: new Text("제목 없음"),
                          content: new Text("제목을 입력해주세요"),
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
                  }else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text("제목 없음"),
                          content: new Text("제목을 입력해주세요"),
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
                  }else{
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
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {0: FractionColumnWidth(.3), 1: FractionColumnWidth(.7)},
                children: [
                  TableRow(
                      children:[
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                          child: GestureDetector(
                              onTap: (){
                                if(wait)
                                  return;

                                FocusScope.of(context).requestFocus(new FocusNode());
                                if(isiOS){
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) => CupertinoActionSheet(
                                        actions: <Widget>[
                                          CupertinoActionSheetAction(
                                            child: const Text('사진 가져오기'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              getImage(ImageSource.gallery);
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: const Text('사진 찍기'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              getImage(ImageSource.camera);
                                            },
                                          )
                                        ],
                                        cancelButton: CupertinoActionSheetAction(
                                          child: const Text('취소'),
                                          isDefaultAction: true,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )),
                                  );
                                }
                                else{
                                  showAdaptiveActionSheet(
                                    context: context,
                                    actions: <BottomSheetAction>[
                                      BottomSheetAction(title: '사진 가져오기', onPressed: () {
                                        Navigator.pop(context);
                                        getImage(ImageSource.gallery);
                                      }),
                                      BottomSheetAction(title: '사진 찍기', onPressed: () {
                                        Navigator.pop(context);
                                        getImage(ImageSource.camera);
                                      }),
                                    ],
                                    cancelAction: CancelAction(title: '취소'),// onPressed parameter is optional by default will dismiss the ActionSheet
                                  );
                                }
                              },
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: PostImage != null ? DecorationImage( image: FileImage(File(PostImage.path)), fit: BoxFit.cover) : null,
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.all(const Radius.circular(5))
                                  ),
                                  child: PostImage != null ? Container():Center(child: Icon(CupertinoIcons.paperclip,color: Colors.grey,),),
                                ),
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CupertinoTextField(
                                controller: Topic_textController,
                                keyboardType: TextInputType.multiline,
                                maxLength: 20,
                                maxLines: 1,
                                placeholder: "제목",
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(5),
                                      topRight: const Radius.circular(5),
                                    )
                                ),
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 1,),
                              CupertinoTextField(
                                controller: Text_textController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 4,
                                maxLength: 100,
                                placeholder: "내용",
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: const Radius.circular(5),
                                      bottomRight: const Radius.circular(5),
                                    )
                                ),
                                style: TextStyle(fontSize: 18,),
                              ),
                            ],
                          ),
                        )
                      ]
                  )
                ],
              )
            )
        ),
      ),
    );
  }

  Future getImage(ImageSource source) async {
    var Nonimage = await ImagePicker().getImage(source: source,imageQuality: 30);
    if(Nonimage == null ) return;
    setState(() {
      PostImage = Nonimage;
    });
  }
  Future Upload() async {
    wait= true;
    EasyLoading.show(status: 'loading...',);

    var downloadUrl;

    var NowMilliTime = DateTime.now().millisecondsSinceEpoch;
    var NowTime = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
    //Post Image
    if (PostImage != null) {
      var ref = await FirebaseStorage.instance.ref();
      var addImg = await ref.child("Post").child(widget.uid).
      child("${widget.uid}${NowMilliTime}").putFile(File(PostImage.path));
      downloadUrl = await addImg.ref.getDownloadURL();
    }
    else{
      downloadUrl = "";
    }

    //write Post Information
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).
    collection("Posts").doc("${widget.uid}${NowMilliTime}").
    set({'Uid':widget.uid,
      'Title':Topic_textController.text,
      'Text':Text_textController.text,'LikeCnt':0,
      'MilliTime':NowMilliTime,'Time':NowTime,
      'Like':[],'Report':[],'Image':downloadUrl});


    EasyLoading.dismiss();
    Navigator.pop(context);
  }
}