import 'dart:convert';

import 'package:chat_app/src/models/users_response.dart';


LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.user,
    this.token,
  });

  User user;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    user: User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "token": token,
  };
}

