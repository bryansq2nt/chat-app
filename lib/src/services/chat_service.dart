

import 'package:chat_app/src/globals/environment.dart';
import 'package:chat_app/src/models/messages_response.dart';
import 'package:chat_app/src/models/user.dart';
import 'package:chat_app/src/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  User userTo;

  Future<List<Message>> getChat({String userId}) async {
    final token = await AuthService.getToken();

    try
    {
      final response = await http.get(Environment.apiUrl + '/messages/$userId',headers: {
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