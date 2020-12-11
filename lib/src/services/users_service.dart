import 'package:chat_app/src/globals/environment.dart';
import 'package:chat_app/src/models/user.dart';
import 'package:chat_app/src/models/users_response.dart';
import 'package:chat_app/src/providers/auth_service.dart';
import 'package:http/http.dart' as http;

class UsersService {




  Future<List<User>> getUsers () async {
    final token = await  AuthService.getToken();

    try
    {
      final response = await http.get(Environment.apiUrl + '/users/onlineUsers', headers: { 'Authorization': token});
      final _usersResponse = usersResponseFromJson(response.body);
      return _usersResponse.users;
    }
    catch (e){
      return null;
    }



  }


}