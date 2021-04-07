import 'package:flutter/material.dart';

class ScreenSocketClient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenSocketClientState();
}

class _ScreenSocketClientState extends State<ScreenSocketClient> {

  TextEditingController _hostController = TextEditingController();
  TextEditingController _portController = TextEditingController();

  Future _connect() async {
    //todo connect to server
  }

  Future _disconnect() async {
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
