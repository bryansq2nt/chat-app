
import 'package:chat_app/src/views/chat_view.dart';
import 'package:chat_app/src/views/chats_views.dart';
import 'package:chat_app/src/views/loading_view.dart';
import 'package:chat_app/src/views/login_view.dart';
import 'package:chat_app/src/views/register_view.dart';
import 'package:chat_app/src/views/contacts_view.dart';
import 'package:flutter/material.dart';

final Map<String,Widget Function(BuildContext)> appRoutes = {
  'contacts': (_) => ContactsView(),
  'chats': (_) => ChatsView(),
  'chat': (_) => ChatView(),
  'login': (_) => LoginView(),
  'register': (_) => RegisterView(),
  'loading': (_) => LoadingView()
};