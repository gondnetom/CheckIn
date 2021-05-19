import 'package:checkschool/MainPage/PartPage/third/Board/Detail_Board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Board_Widget extends StatefulWidget {
  String uid;
  String SchoolName;
  var documents;

  Board_Widget(this.uid,this.SchoolName,this.documents);

  @override
  _Board_WidgetState createState() => _Board_WidgetState();
}

class _Board_WidgetState extends State<Board_Widget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailBaord(widget.uid, widget.SchoolName,widget.documents))
        );
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          decoration: BoxDecoration(
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${widget.documents["Title"]}",style: TextStyle(color: Colors.black,fontSize: 20),),
              SizedBox(height: 1,),
              Text("좋아요: ${widget.documents["Like"].length}",style: TextStyle(color: Colors.black,fontSize: 12),),
              Text("${widget.documents["Uid"]==widget.uid ? "나": widget.documents["Uid"].toString().substring(0,5)}  ${widget.documents["Time"]}",style: TextStyle(color: Colors.black,fontSize: 10),),
            ],
          )
      ),
    );
  }
}
