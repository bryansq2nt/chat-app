

import 'package:chat_app/src/views/chat_view.dart';
import 'package:chat_app/src/views/loading_view.dart';
import 'package:chat_app/src/views/login_view.dart';
import 'package:chat_app/src/views/register_view.dart';
import 'package:chat_app/src/views/users_view.dart';
import 'package:flutter/material.dart';

final Map<String,Widget Function(BuildContext)> appRoutes = {
  'users': (_) => UsersView(),
  'chat': (_) => ChatView(),
  'login': (_) => LoginView(),
  'register': (_) => RegisterView(),
  'loading': (_) => LoadingView()
};