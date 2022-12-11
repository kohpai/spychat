import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:spychat/signaling/encapsulation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SignalingServerConnection extends ChangeNotifier {
  static const String _address = 'ws://192.168.0.106:8080/ws';
  WebSocketChannel? _channel;
  Stream<dynamic>? _stream;
  Future<bool> connect() async {
    _channel ??= WebSocketChannel.connect(Uri.parse(_address));

    _channel!.sink.add(await encapsulatePacket());
    _stream = _channel!.stream.asBroadcastStream();
    final response = (await _stream!.first) as Uint8List;
    developer.log('connect: $response', name: 'me.kohpai.ConnectButton');

    final result = response[0] == 200;
    notifyListeners();
    return result;
  }

  void disconnect() async {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }

    notifyListeners();
  }

  WebSocketSink? getSink() => _channel?.sink;

  Stream<dynamic>? getStream() => _stream;

  bool isConnected() => _channel != null;
}
