import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ScreenSocketClient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenSocketClientState();
}

class _ScreenSocketClientState extends State<ScreenSocketClient> {

  String _theLatestData = '';

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
    _socket.listen((Uint8List dataAsByte) {
      // this function run when has data from server.
      final String data = String.fromCharCodes(dataAsByte);
      setState(() {
        _theLatestData = data;
      });
    });
  }

  void _sendMessageToServer(String message) {
    if (_socket != null) _socket.write(message);
  }

  Future _disconnect() async {
    if (_socket != null) _socket.destroy();
    _socket = null;
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
                alignment: Alignment.center,
                height: 200,
                color: Colors.black,
                child: Text('recieved data:\n' + _theLatestData),
              ),
            ),
            _space(),
            /// data input
            TextField(
              controller: _dataInputController,
            ),
            _space(),
            /// send data
            RaisedButton(
              child: Text('Send'),
              onPressed: () {
                _sendMessageToServer(_dataInputController.text);
              },
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
                RaisedButton(
                  child: Text('Connect'),
                  onPressed: () {
                    _connect();
                  },
                ),
                /// disconnect
                RaisedButton(
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
