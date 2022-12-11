import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spychat/signaling/packet.dart';
import 'package:spychat/signaling/signaling_server_connection.dart';

class TextHistory extends StatefulWidget {
  const TextHistory({super.key});

  @override
  State<StatefulWidget> createState() => _TextHistoryState();
}

class _TextHistoryState extends State<TextHistory> {
  var _texts = [const Text("empty")];

  String decode(String text) {
    final json = text.substring(0, text.lastIndexOf(';'));
    final packet = Packet.fromJson(jsonDecode(json));
    return packet.data!;
  }

  @override
  Widget build(BuildContext context) => Consumer<SignalingServerConnection>(
      builder: (context, conn, child) => conn.isConnected()
          ? StreamBuilder(
          stream: conn.getStream()!,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              _texts += data is String ? [Text(decode(data))] : [];
            }

            return Column(
              children: _texts,
            );
          })
          : Column(
        children: _texts,
      ));
}
