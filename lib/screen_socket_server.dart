import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ScreenSocketServer extends StatefulWidget  {
  @override
  State<StatefulWidget> createState() => _ScreenSocketServerState();
}

class _ScreenSocketServerState extends State<ScreenSocketServer> {
  // ui variables
  String _receivedData = '';
  String _serverStatus = 'server is not running';

  // text input controller for data input to send to clients
  TextEditingController _dataInputController = TextEditingController();

  // server socket object
  ServerSocket? _serverSocket;

  // Connections for each client
  List<Socket> _sockets = [];

  /// starts the server and listen for connections
  Future _startServer() async {
    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
    print('port number: ${_serverSocket!.port.toString()}');
    setState(() {
      _serverStatus = 'server running, port: ${_serverSocket!.port.toString()}';
    });
    _serverSocket!.listen((Socket socket) {
      print('connect new client'); // this function run when connect a client.
      socket.write('connection success');
      _sockets.add(socket);
      socket.listen((Uint8List dataAsByte) {
        print('data received'); // this function run when receive data from client.
        String data = new String.fromCharCodes(dataAsByte);
        setState(() {
          _receivedData += '$data\n';
        });
      });
    });
  }

  /// sends the given message to all clients
  void _sendMessageToAllClients(String message) {
    for (Socket socket in _sockets) {
      socket.write(message);
    }
  }

  /// close all connections and stop the server
  Future _stopServer() async {
    // destroy all clients sockets
    for (Socket socket in _sockets) {
      socket.destroy();
    }
    _sockets.clear();

    // close server
    if (_serverSocket != null) await _serverSocket!.close();
    _serverSocket = null;

    // clear the data from ui
    setState(() {
      _receivedData = '';
      _serverStatus = 'server stopped';
    });
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
          children: [
            // show received data from clients
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                height: 200,
                padding: EdgeInsets.all(8),
                color: Colors.black,
                child: SingleChildScrollView(
                  child: Text('received data:\n$_receivedData'),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // data input to send to clients
            TextField(
              controller: _dataInputController,
              decoration: InputDecoration(
                hintText: 'Type to send data',
              ),
            ),
            const SizedBox(height: 8),

            // send data button
            ElevatedButton(
              child: Text('send'),
              onPressed: () {
                _sendMessageToAllClients(_dataInputController.text);
              },
            ),
            const SizedBox(height: 8),

            // show server status
            Container(
              child: Text(_serverStatus),
            ),
            const SizedBox(height: 8),

            // start and stop server buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // start server
                ElevatedButton(
                  child: Text('Start Server'),
                  onPressed: () {
                    _startServer();
                  },
                ),

                // stop server
                ElevatedButton(
                  child: Text('Stop Server'),
                  onPressed: () {
                    _stopServer();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
