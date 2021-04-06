import 'package:flutter/material.dart';

class ScreenSocketServer extends StatefulWidget  {
  @override
  State<StatefulWidget> createState() => _ScreenSocketServerState();
}

class _ScreenSocketServerState extends State<ScreenSocketServer> {

  void _startServer() async {
    //todo start server
  }

  void _stopServer() async {
    //todo stop server
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOCKET SERVER'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /// show data
          Container(
            alignment: Alignment.center,
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Text(''),
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
    );
  }
}
