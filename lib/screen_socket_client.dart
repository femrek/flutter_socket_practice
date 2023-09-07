import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ScreenSocketClient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenSocketClientState();
}

class _ScreenSocketClientState extends State<ScreenSocketClient> {
  // ui variables
  String _receivedData = '';
  String _connectionStatus = 'not connected';

  // text input controller for data input to send
  TextEditingController _dataInputController = TextEditingController();

  // text input controller for host and port
  TextEditingController _hostController = TextEditingController();
  TextEditingController _portController = TextEditingController();

  // socket variable for connecting to socketServer running on other device
  Socket? _socket;

  /// start the connection
  Future _connect() async {
    final String host = _hostController.text;
    final InternetAddress? hostAddress = InternetAddress.tryParse(host);
    final int? port = int.tryParse(_portController.text);

    // validate host and port
    if (hostAddress == null || port == null) {
      String err = '';
      if (hostAddress == null) {
        err += 'host must be valid\n';
        print('host is not valid');
      }
      if (port == null) {
        err += 'port must be an integer\n';
        print('port number must be integer');
      }
      err = err.substring(0, err.length - 1); // delete the last \n
      setState(() {
        _connectionStatus = err;
      });
      return;
    }

    // connect to server
    try {
      setState(() {
        _connectionStatus = 'connecting...';
      });
      _socket = await Socket.connect(
        hostAddress,
        port,
      );
    } catch (e) {
      setState(() {
        _connectionStatus = 'error when try connect';
      });
      print(e);
      return;
    }
    assert(_socket != null);
    print('connected:${_socket!.remoteAddress.address}:${_socket!.remotePort}');
    setState(() {
      _connectionStatus = 'connected to $host:$port';
    });

    // this function is triggered when receive data from server
    _socket!.listen((Uint8List dataAsByte) {
      // convert data from byte to string
      final String data = String.fromCharCodes(dataAsByte);

      // update the ui
      setState(() {
        _receivedData += '$data\n';
      });
    });
  }

  /// if connected to server, send message to server
  void _sendMessageToServer(String message) {
    if (_socket != null) _socket!.write(message);
  }

  /// destroy connection to server
  Future _disconnect() async {
    if (_socket != null) _socket!.destroy();
    _socket = null;

    // clear the data and update the ui
    setState(() {
      _receivedData = '';
      _connectionStatus = 'disconnected';
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
            // show received data
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                height: 200,
                color: Colors.black,
                child: SingleChildScrollView(
                  child: Text('received data:\n$_receivedData'),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // data input
            TextField(
              controller: _dataInputController,
              decoration: InputDecoration(
                hintText: 'Type to send data',
              ),
            ),
            const SizedBox(height: 8),

            // send data
            ElevatedButton(
              child: Text('Send'),
              onPressed: () {
                _sendMessageToServer(_dataInputController.text);
              },
            ),
            const SizedBox(height: 8),

            // show connection state
            Container(
              child: Text(_connectionStatus),
            ),
            const SizedBox(height: 8),

            // input for host and port
            Row(
              children: [
                // host input
                Expanded(
                  flex: 3,
                  child: TextField(
                      controller: _hostController,
                      decoration: InputDecoration(
                        hintText: 'host',
                      )),
                ),
                SizedBox(width: 16),

                // port input
                Expanded(
                  flex: 2,
                  child: TextField(
                      controller: _portController,
                      decoration: InputDecoration(
                        hintText: 'port',
                      )),
                )
              ],
            ),
            const SizedBox(height: 8),

            // connect and disconnect buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // connect
                ElevatedButton(
                  child: Text('Connect'),
                  onPressed: _connect,
                ),

                // disconnect
                ElevatedButton(
                  child: Text('Disconnect'),
                  onPressed: _disconnect,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
