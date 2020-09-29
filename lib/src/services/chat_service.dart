
import 'package:chat_app/src/globals/environment.dart';
import 'package:chat_app/src/models/chats_response.dart';
import 'package:chat_app/src/models/messages_response.dart';
import 'package:chat_app/src/models/users_response.dart';
import 'package:chat_app/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  User userTo;
  Chat chat;

  Future<List<Chat>> getChats() async {
    final token = await AuthService.getToken();

    try
    {
      final response = await http.get(Environment.apiUrl + '/chat/all',headers: {
        'Authorization': token
      });

      if(response.statusCode == 200){

        final chatsResponse = chatsResponseFromJson(response.body);
        return chatsResponse.chats;
      }
      else
      {
        return [];
      }

    }
    catch (e){
      print(e);
      return [];
    }

  }

  Future<List<Message>> getChat({String fromId, String toId}) async {
    final token = await AuthService.getToken();

    try
    {
      int limit = 15;
      int offset = 0;

      final response = await http.get(Environment.apiUrl + '/chat/private/from/$fromId/to/$toId?limit=$limit&&offset=$offset',headers: {
        'Authorization': token
      });

      if(response.statusCode == 200){
        final messagesResponse = messagesResponseFromJson(response.body);
        return messagesResponse.messages;
      }
      else
        {
          return [];
        }

    }
    catch (e){
      print(e);
      return [];
    }

  }

  Future<List<Message>> getMoreMessages({String fromId, String toId,int limit,  int offset}) async {
    final token = await AuthService.getToken();

    try
    {
      final response = await http.get(Environment.apiUrl + '/chat/private/from/$fromId/to/$toId?limit=$limit&&offset=$offset',headers: {
        'Authorization': token
      });


      if(response.statusCode == 200){
        final messagesResponse = messagesResponseFromJson(response.body);
        return messagesResponse.messages;
      }
      else
      {
        return [];
      }

    }
    catch (e){
      print(e);
      return [];
    }

  }

}