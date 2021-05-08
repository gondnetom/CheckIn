import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AverageList extends StatefulWidget {
  var list;

  AverageList(this.list);

  @override
  _AverageListState createState() => _AverageListState();
}

class _AverageListState extends State<AverageList> {
  var date = int.parse("${DateTime.now().year}${DateTime.now().month~/10 == 0 ? 0:""}${DateTime.now().month}${DateTime.now().day~/10 == 0 ? 0:""}${DateTime.now().day}");
  var ApplyTime;

  @override
  Widget build(BuildContext context) {
    ApplyTime = widget.list["ApplyTime"];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
      decoration: BoxDecoration(
        color: widget.list["Date"]==date ? ( widget.list["SpecialComment"]=="" ? Colors.grey[300]:Colors.amber):Colors.red,
        borderRadius: BorderRadius.all( Radius.circular(7), ),
      ),
      child: widget.list["Date"]==date ?
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${widget.list["Grade"]}${widget.list["Class"]}${widget.list["Number"]~/10==0 ? 0:""}${widget.list["Number"]}",style: TextStyle(fontSize: 20)),
          Text("${widget.list["Name"]} / ${widget.list["NowLocation"]} / ${widget.list["Hour"]}:${widget.list["Minute"]}",style: TextStyle(fontSize: 20)),
          widget.list["SpecialComment"]!="" ? Text("${widget.list["SpecialComment"]}",style: TextStyle(fontSize: 20)) : Container(),

          widget.list["ApplyDate"] == date && widget.list["BackCheck"] && widget.list["NowLocation"] != "조기입실" ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                  height: 20,
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.grey
              ),
              Text("특별실 신청: ${widget.list["ApplyRoom"]}",style: TextStyle(fontSize: 20)),
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
              Text("신청 이유: ${widget.list["ApplyComment"]}",style: TextStyle(fontSize: 20)),
            ],
          ):Container(),
        ],
      ):
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${widget.list["Grade"]}${widget.list["Class"]}${widget.list["Number"]~/10==0 ? 0:""}${widget.list["Number"]}",style: TextStyle(fontSize: 20,color: Colors.white)),
          Text("${widget.list["Name"]} / 출석안함",style: TextStyle(fontSize: 20,color: Colors.white))
        ],
      )
    );
  }
}
