import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:spychat/signaling/encapsulation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
