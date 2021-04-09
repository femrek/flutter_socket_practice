import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ScreenSocketClient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenSocketClientState();
}

class _ScreenSocketClientState extends State<ScreenSocketClient> {

  /// ui data
  String _receivedData = '';
  String _connectionState = 'not connected';

  TextEditingController _dataInputController = TextEditingController();

  TextEditingController _hostController = TextEditingController();
  TextEditingController _portController = TextEditingController();

  Socket _socket;

  Future _connect() async {
    final String host = _hostController.text;
    final int port = int.tryParse(_portController.text);
    if (port == null) print('unvalid port number'); // port must be an integer

    _socket = await Socket.connect(InternetAddress.tryParse(host), port);
    print('connect to ${_socket.remoteAddress.address}:${_socket.remotePort}');
    setState(() {
      _connectionState = 'connected to $host:$port';
    });
    _socket.listen((Uint8List dataAsByte) {
      print('data received'); // this function run when receive data.
      final String data = String.fromCharCodes(dataAsByte);
      setState(() {
        _receivedData += data + '\n';
      });
    });
  }

  void _sendMessageToServer(String message) {
    if (_socket != null) _socket.write(message);
  }

  Future _disconnect() async {
    if (_socket != null) _socket.destroy();
    _socket = null;
    /// clear the data
    setState(() {
      _receivedData = '';
      _connectionState = 'disconnected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOCKET CLIENT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// show data
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                height: 200,
                color: Colors.black,
                child: SingleChildScrollView(
                  child: Text('recieved data:\n' + _receivedData),
                ),
              ),
            ),
            _space(),
            /// data input
            TextField(
              controller: _dataInputController,
              decoration: InputDecoration(
                hintText: 'Type to send data',
              ),
            ),
            _space(),
            /// send data
            ElevatedButton(
              child: Text('Send'),
              onPressed: () {
                _sendMessageToServer(_dataInputController.text);
              },
            ),
            _space(),
            /// show connection state
            Container(
              child: Text(_connectionState),
            ),
            _space(),
            Row(
              children: [
                /// host input
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _hostController,
                  ),
                ),
                SizedBox(width: 16,),
                /// port input
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _portController,
                  ),
                )
              ],
            ),
            _space(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// connect
                ElevatedButton(
                  child: Text('Connect'),
                  onPressed: () {
                    _connect();
                  },
                ),
                /// disconnect
                ElevatedButton(
                  child: Text('Disconnect'),
                  onPressed: () {
                    _disconnect();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _space({bool vertical = true}) {
    return SizedBox(
      height: vertical ? 8 : 0,
      width: vertical ? 0 : 8,
    );
  }
}
