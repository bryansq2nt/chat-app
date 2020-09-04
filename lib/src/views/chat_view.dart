import 'dart:io';

import 'package:chat_app/src/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>  with TickerProviderStateMixin{
  final _inputController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _isWriting = false;

  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(
                "TE",
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Test user',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: this._messages.length,
                  itemBuilder: (context, i) => this._messages[i]),
            ),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: this._inputController,
                onSubmitted: _isWriting ?
                    (_) => _handleSubmit(this._inputController.text.trim()) :
                null,
                onChanged: (message) {
                 setState(() {
                   if(message.trim().length > 0 ){
                     _isWriting = true;
                   }
                   else
                   {
                     _isWriting = false;
                   }
                 });
                },
                decoration: InputDecoration.collapsed(hintText: 'Write...'),
                focusNode: this._focusNode,

              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS ?
              CupertinoButton(
                child: Text("Enviar"),
                onPressed: _isWriting ?
                    () => _handleSubmit(this._inputController.text.trim()) :
                null,
              ) :
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconTheme(
                  data: IconThemeData(
                    color: Colors.blue[400]
                  ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.send),
                    onPressed: _isWriting ?
                        () => _handleSubmit(this._inputController.text.trim()) :
                        null,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String message){


    final newMessage = new ChatMessage(
      uid: '123',
      text: message,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 500 )),
    );

    this._messages.insert(0, newMessage);
    newMessage.animationController.forward();

    this._inputController.clear();
    this._focusNode.requestFocus();

    setState(() {
      _isWriting = false;
    });

  }

  @override
  void dispose() {
    //TODO off socket,
    for( ChatMessage message in this._messages){
      message.animationController.dispose();
    }

    super.dispose();
  }

}
