import 'dart:convert';

import 'package:chat_app/src/models/users_response.dart';

import 'messages_response.dart';

ChatsResponse chatsResponseFromJson(String str) => ChatsResponse.fromJson(json.decode(str));

String chatsResponseToJson(ChatsResponse data) => json.encode(data.toJson());

class ChatsResponse {
  ChatsResponse({
    this.chats,
  });

  List<Chat> chats;

  factory ChatsResponse.fromJson(Map<String, dynamic> json) => ChatsResponse(
    chats: List<Chat>.from(json["chats"].map((x) => Chat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "chats": List<dynamic>.from(chats.map((x) => x.toJson())),
  };
}

class Chat {
  Chat({
    this.id,
    this.messages,
    this.from,
    this.to,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  List<Message> messages;
  User from;
  User to;
  DateTime createdAt;
  DateTime updatedAt;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json['id'],
    messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
    from: User.fromJson(json["from"]),
    to: User.fromJson(json["to"]),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
    "from": from.toJson(),
    "to": to.toJson(),
    "created_at": createdAt.toIso8601String(),
  };
}


