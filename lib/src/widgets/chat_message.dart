import 'package:chat_app/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final bool readed;
  final DateTime date;
  final AnimationController animationController;

  const ChatMessage({
    Key key,
    @required this.text,
    @required this.uid,
    @required this.animationController,
    @required this.readed,
    @required this.date
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthService>(context);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOut
        ),
        child: Container(
          child: this.uid == authProvider.user.uid ?
          _myMessage() :
          _notMyMessage(),

        ),
      ),
    );
  }


  Widget _myMessage(){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 10, left: 50, right: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(this.text, style: TextStyle(color: Colors.white),)
            ),
            Container(
                margin: EdgeInsets.only(top: 10, left: 10),
                child: Text("${DateFormat('hh:mm a').format(this.date)}", style: TextStyle(color: Colors.white54),)
            ),
            // !this.readed ? Container(
            //     margin: EdgeInsets.only(top: 10, left: 10),
            //     child: Icon(Icons.check,size: 10,color: Colors.white,)
            // ) : Container(
            //     margin: EdgeInsets.only(top: 10, left: 10),
            //     child: Row(
            //       children: <Widget>[
            //         Icon(Icons.check,size: 10,color: Colors.white,),
            //         Icon(Icons.check,size: 10,color: Colors.white,)
            //       ],
            //     )
            // )
          ],
        )
      ),
    );
  }

  Widget _notMyMessage(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 5, left: 7, right: 50),
        child: Text(this.text, style: TextStyle(color: Colors.black87),),
      ),
    );
  }
}
