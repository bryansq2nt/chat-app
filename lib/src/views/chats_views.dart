import 'package:chat_app/src/models/chats_response.dart';
import 'package:chat_app/src/models/messages_response.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/services/chat_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatsView extends StatefulWidget {
  @override
  _ChatsViewState createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final _chatsService = ChatService();
  List<Chat> _chats = [];
  SocketService _socketService;



  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    this._loadUsers();
    this._socketService = Provider.of<SocketService>(context,listen: false);

    this._socketService.socket.on('private-message',_newMessage);

    super.initState();
  }




  void _newMessage(dynamic data){
    for(int i =0; i < this._chats.length; i++){
      if(this._chats[i].from == data['from']){

        setState(() {
          this._chats[i].messages.insert(0, Message.fromJson(data));
        });
      }
    }
  }

  @override
  void dispose() {

    this._socketService.socket.off('private-message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Messenger",
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.contacts, color: Colors.blue[400],),
                onPressed: (){
                  Navigator.pushReplacementNamed(context, 'contacts');
                },
              )
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _loadUsers,
          enablePullDown: true,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.blue[400],
            ),
            waterDropColor: Colors.blue[400],
          ),
          child: _chatsListView(),
        ));
  }

  ListView _chatsListView() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: this._chats.length,
        separatorBuilder: (_, i) => Divider(),
        itemBuilder: (_, i) => _chatTile(message: _chats[i].messages[0], index: i));
  }

  ListTile _chatTile({Message message, int index}) {
    return ListTile(
      title: Text(_chats[index].to.name),
      subtitle: Text(message.message),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(_chats[index].to.name.substring(0, 2)),
      ),
      trailing: _chats[index].messages.length > 0
          ? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(100)
        ),
        child: Center(child: Text(_chats[index].messages.length < 100 ? "${_chats[index].messages.length}" : "99+", style: TextStyle(color: Colors.white),)),
      )
          : Container(
        child: Text( "${DateFormat('hh:mm a').format(message.createdAt)}" ),
      ),
      onTap: (){
        final chatService = Provider.of<ChatService>(context,listen: false);
        chatService.userTo = _chats[index].to;
        chatService.chat = _chats[index];
        setState(() {

        });
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _loadUsers() async {
    var updatedChats = await _chatsService.getChats();

    if (updatedChats != null) {
      this._chats = updatedChats;
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
    setState(() {});
  }
}
