import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class An_Chat_Page extends StatefulWidget {
  String uid;
  String SchoolName;

  An_Chat_Page(this.uid,this.SchoolName);

  @override
  _An_Chat_PageState createState() => _An_Chat_PageState();
}
class _An_Chat_PageState extends State<An_Chat_Page> {
  List<DocumentSnapshot> documents;
  Stream<QuerySnapshot> currentStream;

  // 텍스트필드 제어용 컨트롤러
  final TextEditingController _textController = TextEditingController();
  // 텍스트필드에 입력된 데이터의 존재 여부
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    currentStream = FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).
    collection("Chat").orderBy("NowTime",descending: true).limit(100).snapshots();

    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon:Icon(CupertinoIcons.left_chevron,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder(
        stream: currentStream,
        builder: (context,snapshot){
          if(snapshot.hasData){
            documents = snapshot.data.docs;
            return Container(
              child: Column(
                children: <Widget>[
                  // 리스트뷰 추가
                  Flexible(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        // 리스트뷰의 스크롤 방향을 반대로 변경. 최신 메시지가 하단에 추가됨
                        reverse: true,
                        itemCount: documents.length,
                        itemBuilder: (context,index){
                          return ChatModule(documents[index]["uid"],documents[index]["Text"]);
                        }
                    ),
                  ),
                  // 구분선
                  Divider(height: 1.0),
                  // 메시지 입력을 받은 위젯(_buildTextCompose)추가
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: _buildTextComposer(),
                  )
                ],
              ),
            );
          }else{
            return Center(child: CupertinoActivityIndicator());
          }

        },
      )
    );
  }
  
  // Chat의 모양
  Widget ChatModule(String Textuid,String TextText){
    if(Textuid == widget.uid){
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 280),
            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all( Radius.circular(7),),
            ),
            child: Text(TextText,style: TextStyle(color: Colors.white,fontSize: 20),),
          ),
        ],
      );
    }else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 280),
            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all( Radius.circular(7),),
            ),
            child: Text(TextText,style: TextStyle(color: Colors.black,fontSize: 20),),
          ),
        ],
      );
    }
  }

  // 사용자로부터 메시지를 입력받는 위젯 선언
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            // 텍스트 입력 필드
            Flexible(
              child: TextField(
                controller: _textController,
                // 입력된 텍스트에 변화가 있을 때 마다
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                // 키보드상에서 확인을 누를 경우. 입력값이 있을 때에만 _handleSubmitted 호출
                onSubmitted: _isComposing ? _handleSubmitted : null,
                // 텍스트 필드에 힌트 텍스트 추가
                decoration:
                InputDecoration.collapsed(hintText: "Send a Message"),
              ),
            ),
            // 전송 버튼
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              // 플랫폼 종류에 따라 적당한 버튼 추가
              child: IconButton(
                // 아이콘 버튼에 전송 아이콘 추가
                icon: Icon(Icons.send),
                // 입력된 텍스트가 존재할 경우에만 _handleSubmitted 호출
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
              )
            ),
          ],
        ),
      ),
    );
  }
  // 메시지 전송 버튼이 클릭될 때 호출
  Future _handleSubmitted(String text) async{
    var NowTime = DateTime.now().millisecondsSinceEpoch;

    // 텍스트 필드의 내용 삭제
    _textController.clear();
    // _isComposing을 false로 설정
    setState(() {
      _isComposing = false;
    });

    await FirebaseFirestore.instance.collection("Users").doc(widget.SchoolName).collection("Chat").doc("${widget.uid}${NowTime}").
    set({"NowTime":NowTime,"uid":widget.uid,"Text":text});
  }
}