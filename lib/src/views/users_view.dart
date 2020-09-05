import 'package:chat_app/src/models/user.dart';
import 'package:chat_app/src/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersView extends StatefulWidget {



  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final List<User>  users = [
    new User(uid: '1', name: 'Ivis', email: 'Ivis@gmail.com', online: true),
    new User(uid: '2', name: 'Bryan', email: 'Bryan@gmail.com', online: true),
    new User(uid: '3', name: 'Alex', email: 'Alex@gmail.com', online: false),
    new User(uid: '4', name: 'Becky', email: 'Becky@gmail.com', online: true),
    new User(uid: '5', name: 'Marta', email: 'Marta@gmail.com', online: false),
    new User(uid: '6', name: 'Hugo', email: 'Hugo@gmail.com', online: true),
    new User(uid: '7', name: 'Victor', email: 'Victor@gmail.com', online: false),
    new User(uid: '8', name: 'Damaris', email: 'Damaris@gmail.com', online: true),
    new User(uid: '9', name: 'Walter', email: 'Walter@gmail.com', online: true),

  ];

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);




  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(authService.user.name, style: TextStyle(color: Colors.black87),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black87,),
          onPressed: (){
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();

          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child:
            Icon(Icons.check_circle,color: Colors.blue[400],),
            //Icon(Icons.offline_bolt,color: Colors.red[400],),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _loadUsers,
        enablePullDown: true,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400],),
          waterDropColor: Colors.blue[400],
        ),
        child: _usersListView(),
      )
    );
  }

  ListView _usersListView() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
              itemCount: this.users.length,
              separatorBuilder: (_,i) => Divider(),
              itemBuilder: (_,i) => _userTile(users[i])
            );
  }

  ListTile _userTile(User user) {
    return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(user.name.substring(0,2)),
                ),
                trailing: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: user.online ? Colors.green[300] : Colors.red,
                    borderRadius: BorderRadius.circular(100)
                  ),
                ),
              );
  }

  _loadUsers() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
