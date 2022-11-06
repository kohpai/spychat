import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:spychat/key_pem_display.dart';
import 'package:spychat/signaling/encapsulation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        body: Center(
          child: KeyPemDisplay(),
        ),
        floatingActionButton: const ConnectButton(),
      ),
    );
  }
}

class ConnectButton extends StatefulWidget {
  const ConnectButton({super.key});

  @override
  State<StatefulWidget> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
  bool _isConnected = false;
  WebSocketChannel? _channel;

  Future<bool> connectSignalingServer() async {
    _channel =
        WebSocketChannel.connect(Uri.parse('ws://192.168.0.106:8080/ws'));
    _channel!.sink.add(await encapsulatePacket());
    final response = (await _channel!.stream.first) as String;
    developer.log('connect: $response', name: 'me.kohpai.ConnectButton');
    return response == 'successful';
  }

  Future<dynamic> disconnectSignalingServer() => _channel!.sink.close();

  void toggleConnection() async {
    var isConnected = false;
    if (_isConnected) {
      await disconnectSignalingServer();
    } else {
      isConnected = await connectSignalingServer();
    }
    // developer.log('channel: ', name: 'me.kohpai.ConnectButton');

    setState(() {
      _isConnected = isConnected;
    });
  }

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        onPressed: toggleConnection,
        child: Icon(_isConnected ? Icons.cloud_done : Icons.cloud_off),
      );
}
