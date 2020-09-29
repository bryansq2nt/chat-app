import 'dart:convert';


MessagesResponse messagesResponseFromJson(String str) => MessagesResponse.fromJson(json.decode(str));

String messagesResponseToJson(MessagesResponse data) => json.encode(data.toJson());

class MessagesResponse {
  MessagesResponse({
    this.messages,
  });

  List<Message> messages;

  factory MessagesResponse.fromJson(Map<String, dynamic> json) => MessagesResponse(
    messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    this.readed,
    this.from,
    this.to,
    this.message,
    this.chat,
    this.createdAt,
    this.updatedAt,
  });

  bool readed;
  String from;
  String to;
  String message;
  String chat;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    readed: json["readed"],
    from: json["from_id"],
    to: json["to_id"],
    message: json["message"],
    chat: json["chat_room_id"],
    createdAt: DateTime.parse(json["created_at"])
  );

  Map<String, dynamic> toJson() => {
    "readed": readed,
    "from_id": from,
    "to_id": to,
    "message": message,
    "chat_room_id": chat,
    "created_at": createdAt.toIso8601String()
  };
}


