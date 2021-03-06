
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;


enum ServerStatus {
  Online, 
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;


  SocketService(){
    this._initConfig();
  }

  void _initConfig() {
    // Dart client
    this._socket = IO.io('https://name-band-server.herokuapp.com/', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    this._socket.on('connect', (_) {
     print('Conectado al socket');
     this._serverStatus = ServerStatus.Online;
     notifyListeners();
    });
    this._socket.on('disconnect', (_) {
      print('Desconectado del socket');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    // socket.on('nuevo-mensaje', ( payload ) {
    //   print('nuevo-menaje: $payload');
    //   print('nombre: ' + payload['nombre']);
    //   print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
    // });
  }


  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
}