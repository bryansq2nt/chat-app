import 'package:chat_app/src/globals/environment.dart';
import 'file:///D:/Proyectos/MurgasMedia/Flutter/chat_app/lib/src/services/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

enum ServerStatus { Online, Offline, Connecting }
class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get status => _serverStatus;
  IO.Socket get socket => _socket;


  void connect() async {

    final token = await AuthService.getToken();

    this._socket = IO.io(Environment.socketUrl,{
      'transports':['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'Authorization': token
      }
    });


    socket.on('connect', (_) {
      print('Connected to sockets with id: ${socket.id}');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();

    });

    socket.on('disconnect', (_) {
      print('Disconnected from sockets');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });



  }

  void disconnect() {
    this._socket.disconnect();
    this._serverStatus = ServerStatus.Offline;
    notifyListeners();
  }

}