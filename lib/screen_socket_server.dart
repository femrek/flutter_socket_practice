import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ScreenSocketServer extends StatefulWidget  {
  @override
  State<StatefulWidget> createState() => _ScreenSocketServerState();
}

class _ScreenSocketServerState extends State<ScreenSocketServer> {

  TextEditingController _dataInputController = TextEditingController();

  ServerSocket _serverSocket;

  /// Connections for each client
  List<Socket> _sockets = List();

  String _theLatestData = '';

  Future _startServer() async {
    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
    print('LocalHostConnectEvent event, ip: ${_serverSocket.address.toString()}:${_serverSocket.port.toString()}');
    _serverSocket.listen((Socket socket) {
      // this function run when connect a client.
      socket.write('connection success');
      _sockets.add(socket);
      socket.listen((Uint8List dataAsByte) {
        // this function run when has data from client.
        String data = new String.fromCharCodes(dataAsByte);
        setState(() {
          _theLatestData = data;
        });
      });
    });
  }

  void _sendMessageToAllClients(String message) {
    for (int i = 0; i < _sockets.length; i++) {
      _sockets[i].write(message);
    }
  }

  Future _stopServer() async {
    if (_serverSocket != null) _serverSocket.close(); // close server
    _serverSocket = null;
    for (int i = 0; i < _sockets.length; i++) { // destroy all clients sockets
      if (_sockets[i] != null) _sockets[i].destroy();
      _sockets.removeAt(i);
    }
    _sockets.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOCKET SERVER'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// show data
            Container(
              alignment: Alignment.center,
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Text(_theLatestData),
            ),
            /// data input
            TextField(
              controller: _dataInputController,
            ),
            /// send data button
            RaisedButton(
              child: Text('send'),
              onPressed: () {
                _sendMessageToAllClients(_dataInputController.text);
              },
            ),
            /// start server
            RaisedButton(
              child: Text('Start Server'),
              onPressed: () {
                _startServer();
              },
            ),
            /// stop server
            RaisedButton(
              child: Text('Stop Server'),
              onPressed: () {
                _stopServer();
              },
            ),
          ],
        ),
      ),
    );
  }
}
