import 'dart:convert';

UsersResponse usersResponseFromJson(String str) => UsersResponse.fromJson(json.decode(str));

String usersResponseToJson(UsersResponse data) => json.encode(data.toJson());

class UsersResponse {
  UsersResponse({
    this.users,
  });

  List<User> users;

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class User {
  User({
    this.online,
    this.name,
    this.email,
    this.uid,
    this.unReadedMessages,
  });

  bool online;
  String name;
  String email;
  String uid;
  int unReadedMessages;

  factory User.fromJson(Map<String, dynamic> json) => User(
    online: json["online"],
    name: json["name"],
    email: json["email"],
    uid: json["user_id"],
    unReadedMessages: json["un_readed_messages"] == null ? null : json["un_readed_messages"],
  );

  Map<String, dynamic> toJson() => {
    "online": online,
    "name": name,
    "email": email,
    "uid": uid,
    "un_readed_messages": unReadedMessages == null ? null : unReadedMessages,
  };
}
