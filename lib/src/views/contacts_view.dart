import 'package:chat_app/src/models/chats_response.dart';
import 'package:chat_app/src/models/users_response.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:chat_app/src/services/chat_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
import 'package:chat_app/src/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContactsView extends StatefulWidget {
  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final _usersService = UsersService();
  List<User> _users = [];



  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    this._loadUsers();


    super.initState();
  }






  @override
  void dispose() {
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

          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.chat,color: Colors.blue[400],),
                onPressed: (){
                  Navigator.pushReplacementNamed(context, "chats");
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
          child: _usersListView(),
        ));
  }

  ListView _usersListView() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: this._users.length,
        separatorBuilder: (_, i) => Divider(),
        itemBuilder: (_, i) => _userTile(user: _users[i], index: i));
  }

  ListTile _userTile({User user, int index}) {
    final authService = Provider.of<AuthService>(context,listen: false);

    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ?  Colors.green[400] : Colors.grey,
            borderRadius: BorderRadius.circular(100)
        )
      ),
      onTap: (){
        final chatService = Provider.of<ChatService>(context,listen: false);
        chatService.userTo = user;
        chatService.chat = new Chat(from: authService.user, to: user);
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _loadUsers() async {
    var updatedUsers = await _usersService.getUsers();

    if (updatedUsers != null) {
      this._users = updatedUsers;
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
    setState(() {});
  }
}
