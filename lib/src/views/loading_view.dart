import 'package:chat_app/src/providers/auth_service.dart';
import 'package:chat_app/src/services/socket_service.dart';
import 'package:chat_app/src/views/login_view.dart';
import 'package:chat_app/src/views/users_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: ( context, snapshot) {
          return Center(
            child: Text('Wait...'),
          );
        },

      ),
    );
  }

  Future checkLoginState( BuildContext context ) async {

    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context,listen: false);
    final authenticated = await authService.isLoggedIn();

    if ( authenticated ) {
      socketService.connect();
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: ( _, __, ___ ) => UsersView(),
              transitionDuration: Duration(milliseconds: 0)
          )
      );
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: ( _, __, ___ ) => LoginView(),
              transitionDuration: Duration(milliseconds: 0)
          )
      );
    }

  }

}
