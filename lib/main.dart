import 'package:flutter/material.dart';
import 'package:socket_practice/screen_socket_client.dart';
import 'package:socket_practice/screen_socket_server.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      routes: {
        '/': (_) => ScreenHome(),
        '/server': (_) => ScreenSocketServer(),
        '/client': (_) => ScreenSocketClient(),
      },
    );
  }
}

class ScreenHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOCKET'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// go to server screen
            ElevatedButton(
              child: Text('server'),
              onPressed: () {
                Navigator.pushNamed(context, '/server');
              },
            ),

            /// go to client screen
            ElevatedButton(
              child: Text('client'),
              onPressed: () {
                Navigator.pushNamed(context, '/client');
              },
            )
          ],
        ),
      ),
    );
  }
}
