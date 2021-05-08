import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteList extends StatefulWidget {
  String SchoolName;
  var list;

  DeleteList(this.SchoolName,this.list);

  @override
  _DeleteListState createState() => _DeleteListState();
}
class _DeleteListState extends State<DeleteList> {
  Future AccessId() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.list["DeviceId"]).
    update({"Access":true});
  }

  Future DeleteId() async{
    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Users").doc(widget.list["DeviceId"]).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all( Radius.circular(7), ),
        ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.list["Grade"]}${widget.list["Class"]}${widget.list["Number"]~/10==0 ? 0:""}${widget.list["Number"]}",style: TextStyle(fontSize: 20)),
                Text("${widget.list["Name"]}",style: TextStyle(fontSize: 20))
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(CupertinoIcons.xmark),
                    onPressed: (){
                      DeleteId();
                    }
                ),
                !widget.list["Access"] ?
                IconButton(
                    icon: Icon(CupertinoIcons.check_mark),
                    onPressed: (){
                      AccessId();
                    }
                ): Container(),
              ],
            )
          ],
        )
    );
  }
}
