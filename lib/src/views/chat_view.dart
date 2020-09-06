import 'dart:io';

import 'package:chat_app/src/models/messages_response.dart';
import 'package:chat_app/src/providers/auth_service.dart';
import 'package:chat_app/src/services/chat_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
import 'package:chat_app/src/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>  with TickerProviderStateMixin{
  final _inputController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _isWriting = false;

  ChatService _chatService;
  SocketService _socketService;
  AuthService _authService;

  List<ChatMessage> _messages = [];

  @override
  void initState() {
    this._chatService = Provider.of<ChatService>(context,listen: false);
    this._socketService = Provider.of<SocketService>(context,listen: false);
    this._authService = Provider.of<AuthService>(context,listen: false);

    this._socketService.socket.on('private-message',_getNewMessages);

    _loadHistory(this._chatService.userTo.uid);


    super.initState();
  }

  void _loadHistory(String userId) async {
    List<Message> chat = await this._chatService.getChat(userId: userId);
    final history = chat.map((m) => new ChatMessage(
      text: m.message,
      uid: m.from,
      animationController: new AnimationController(vsync: this, duration: Duration(microseconds: 0))..forward(),
    ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _getNewMessages(dynamic data){
    ChatMessage newMessage = new ChatMessage(
        text: data['message'],
        uid: data['from'],
        animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 500 ))
    );
    setState(() {
      this._messages.insert(0, newMessage);
    });
    newMessage.animationController.forward();


  }


  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final userTo = chatService.userTo;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(userTo.name.substring(0,2),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(
              height: 3,
            ),
            Text(userTo.name,
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
              height: 15,
               color: Colors.transparent,
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
      uid: this._authService.user.uid,
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
    
    this._socketService.socket.emit('private-message',{
      'from': this._authService.user.uid,
      'to': this._chatService.userTo.uid,
      'message': message
    });

  }

  @override
  void dispose() {
    this._socketService.socket.off('private-message');
    for( ChatMessage message in this._messages){
      message.animationController.dispose();
    }

    super.dispose();
  }

}
