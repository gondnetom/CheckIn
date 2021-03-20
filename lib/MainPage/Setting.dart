import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatelessWidget {
  void _launchURL(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Setting",style: GoogleFonts.quicksand(fontSize: 30,color: Colors.black),),
        actions: [
          IconButton(
            icon:Icon(CupertinoIcons.xmark,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("앱 관련",style: TextStyle(fontSize: 19),),
          ),
          ListTile(
            tileColor: Colors.grey[300],
            leading:Icon(CupertinoIcons.news,color: Colors.black,size: 30,),
            title:Text("사용법",style: GoogleFonts.nanumGothicCoding(fontSize: 24)),
            trailing: Icon(CupertinoIcons.right_chevron,color: Colors.black,),
            onTap: (){
              _launchURL("https://sites.google.com/view/checkingbs/%ED%99%88");
            },
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("앱 오류",style: TextStyle(fontSize: 19),),
          ),
          ListTile(
            tileColor: Colors.grey[300],
            leading:Icon(CupertinoIcons.tray_arrow_down,color: Colors.black,size: 30,),
            title:Text("문제점 연락",style: GoogleFonts.nanumGothicCoding(fontSize: 24)),
            trailing: Icon(CupertinoIcons.right_chevron,color: Colors.black,),
            onTap: (){
              _launchURL("https://forms.gle/TBR7869nuakWcKxu7");
            },
          ),
        ],
      )
    );
  }
}
