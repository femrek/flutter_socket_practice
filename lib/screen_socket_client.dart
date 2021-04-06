import 'package:flutter/material.dart';

class ScreenSocketClient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenSocketClientState();
}

class _ScreenSocketClientState extends State<ScreenSocketClient> {

  void _connect() async {
    //todo connect to server
  }

  void _disconnect() async {
    //todo disconnect
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOCKET CLIENT'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// show data
          Container(
            alignment: Alignment.center,
            height: 200,
            child: Text(''),
          ),
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
    );
  }
}
