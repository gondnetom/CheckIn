import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RequestList extends StatefulWidget {
  var documents;
  String SchoolName;
  String DeviceId;

  RequestList(this.documents,this.DeviceId,this.SchoolName);

  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  var ApplyTime = Map();
  TextEditingController _tec = TextEditingController();

  Future OK() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.DeviceId).
    update({"BackComment":_tec.text,"BackCheck":true});
  }
  Future Reject() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.DeviceId).
    update({"BackComment":_tec.text,"BackCheck":false});
  }

  @override
  Widget build(BuildContext context) {
    ApplyTime = widget.documents["ApplyTime"];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all( Radius.circular(7), ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //name
          Text("${widget.documents["Grade"]}${widget.documents["Class"]}${widget.documents["Number"]~/10 == 0 ? 0 :""}${widget.documents["Number"]} ${widget.documents["Name"]}",style: TextStyle(fontSize: 20)),
          SizedBox(height: 10,),

          //Room
          Text("특별실 신청: ${widget.documents["ApplyRoom"]}",style: TextStyle(fontSize: 20)),
          SizedBox(height: 10,),
          //Check TIme
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text("1교시",style:TextStyle(fontSize: 19)),
                  Checkbox(
                    value: ApplyTime["First"],
                  )
                ],
              ),
              Column(
                children: [
                  Text("2교시",style:TextStyle(fontSize: 19)),
                  Checkbox(
                    value: ApplyTime["Second"],
                  )
                ],
              ),
              Column(
                children: [
                  Text("3교시",style:TextStyle(fontSize: 19)),
                  Checkbox(
                    value: ApplyTime["Third"],
                  )
                ],
              ),
              Column(
                children: [
                  Text("4교시",style:TextStyle(fontSize: 19)),
                  Checkbox(
                    value: ApplyTime["Forth"],
                  )
                ],
              )
            ],
          ),
          //Reason
          Text("신청 이유: ${widget.documents["ApplyComment"]}",style: TextStyle(fontSize: 20)),
          Divider(
              height: 20,
              thickness: 3,
              indent: 10,
              endIndent: 10,
              color: Colors.grey
          ),

          //result
          widget.documents["BackComment"] == "" ?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _tec,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: '의견',
                      hintStyle: TextStyle(color: Colors.grey)
                  ),
                  cursorColor: Colors.grey,
                )
              ),
              GestureDetector(
                onTap: (){
                  if(_tec.text == ""){
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message:
                        "의견을 입력해주세요.",
                      ),
                    );
                    return;
                  }
                  OK();
                },
                child: Icon(CupertinoIcons.check_mark,size: 30,color: Colors.green,),
              ),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  if(_tec.text == ""){
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message:
                        "의견을 입력해주세요.",
                      ),
                    );
                    return;
                  }
                  Reject();
                },
                child: Icon(CupertinoIcons.xmark,size: 30,color: Colors.red,),
              )
            ],
          ):
          Row(
            children: [
              Text("신청 결과:",style:TextStyle(fontSize: 20)),
              SizedBox(width: 10,),
              widget.documents["BackCheck"] ?
              Icon(CupertinoIcons.check_mark,color: Colors.black,):
              Icon(CupertinoIcons.xmark,color: Colors.black,),
            ],
          ),

          //Commnet
          widget.documents["BackComment"] != "" ?
          Text("의견: ${widget.documents["BackComment"]}",style:TextStyle(fontSize: 20)):Container(),
        ],
      ),
    );
  }
}
