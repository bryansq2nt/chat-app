

import 'dart:convert';
import 'package:chat_app/src/globals/environment.dart';
import 'package:chat_app/src/models/login_response.dart';
import 'package:chat_app/src/models/users_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class AuthService with ChangeNotifier {

  User user;
  bool _authenticating = false;
  final _storage = new FlutterSecureStorage();

  bool get authenticating => this._authenticating;
  set authenticating (bool value){
    this._authenticating = value;
    notifyListeners();
  }



  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login ({String email, String password}) async {
    email = email.trim();
    this.authenticating = true;

    final data = {
      'email': email,
      'password': password
    };

    final resp = await http.post('${Environment.apiUrl}/auth/login',
      body: jsonEncode(data),
      headers: {
      'Content-Type': 'application/json'
      }
    );


    if(resp.statusCode == 200){
      final LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(resp.body));
      this.user = loginResponse.user;
      this.authenticating = false;
      this._saveToken(loginResponse.token);
      return true;
    }
    else
      {
        this.authenticating = false;

        return false;
      }


  }

  Future register({String name, String email, String password }) async {

    this.authenticating = true;

    final data = {
      'name': name,
      'email': email,
      'password': password
    };

    final resp = await http.post('${ Environment.apiUrl }/auth/signup',
        body: jsonEncode(data),
        headers: { 'Content-Type': 'application/json' }
    );

    this.authenticating = false;

    if ( resp.statusCode == 201 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['error'];
    }

  }

  Future<bool> isLoggedIn() async {

    final token = await this._storage.read(key: 'token');

    final resp = await http.get('${ Environment.apiUrl }/auth/refresh',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token
        }
    );

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }

  }

  Future _saveToken( String token ) async {
    return await this._storage.write(key: 'token', value: token );
  }

  Future logout() async {
    await this._storage.delete(key: 'token');
  }

}