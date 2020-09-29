import 'dart:io';

import 'package:chat_app/src/models/messages_response.dart';
import 'package:chat_app/src/services/auth_service.dart';
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
  final _chatController = new ScrollController();

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
    this._socketService.socket.emit('read-all-messages',{ "from_id":  _chatService.chat.to.uid, "to_id":  _chatService.chat.from.uid});

    _loadHistory();


    super.initState();
  }

  void _loadHistory() async {
    if(this._chatService.chat != null){
      List<Message> chat = await this._chatService.getChat(fromId: this._chatService.chat.from.uid, toId: this._chatService.chat.to.uid);
      final history = chat.map((m) => new ChatMessage(
        text: m.message,
        uid: m.from,
        readed: m.readed,
        date: m.createdAt,
        animationController: new AnimationController(vsync: this, duration: Duration(microseconds: 0))..forward(),
      ));

      setState(() {
        this._messages.insertAll(0, history);
      });
    }
    else
      {
        print("New chat");
      }

  }

  void _getNewMessages(dynamic data){
    print(data);
    ChatMessage newMessage = new ChatMessage(
        text: data['message'],
        uid: data['from_id'],
        readed: true,
        date: DateTime.now(),
        animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 500 ))
    );
    setState(() {
      this._messages.insert(0, newMessage);
    });
    newMessage.animationController.forward();


  }

  void _loadMoreMessages() async {
    List<Message> chat = await this._chatService.getMoreMessages(fromId: this._authService.user.uid,toId: this._chatService.userTo.uid,limit: 10,offset: this._messages.length);
    final history = chat.map((m) => new ChatMessage(
      text: m.message,
      uid: m.from,
      readed: m.readed,
      date: m.createdAt,
      animationController: new AnimationController(vsync: this, duration: Duration(microseconds: 0))..forward(),
    ));

    setState(() {
      _messages.addAll( history);
    });
  }


  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final userTo = chatService.userTo;

    if(!this._chatController.hasListeners){
      this._chatController.addListener(() {
        if(this._chatController.position.pixels == this._chatController.position.maxScrollExtent){
          _loadMoreMessages();
        }
      });
    }

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
                controller: this._chatController,
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

      uid: _chatService.chat.from.uid,
      text: message,
      readed: false,
      date: DateTime.now(),
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
      'chat_room_id': this._chatService.chat.id,
      'from_id': this._chatService.chat.from.uid,
      'to_id': this._chatService.chat.to.uid,
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
