import 'dart:convert';

import 'package:basic_utils/basic_utils.dart' as util;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spychat/signaling/encapsulation.dart';
import 'package:spychat/signaling/packet.dart';
import 'package:spychat/signaling/signaling_server_connection.dart';

class TextHistory extends StatefulWidget {
  const TextHistory({super.key});

  @override
  State<StatefulWidget> createState() => _TextHistoryState();
}

class _TextHistoryState extends State<TextHistory> {
  var _texts = [const Text("empty")];

  Future<String> decode(String text) async {
    var sepIndex = text.lastIndexOf(';');
    final json = text.substring(0, sepIndex);
    final signature = text.substring(sepIndex + 1);
    final packet = Packet.fromJson(jsonDecode(json));

    if (!(await verifyPacket(packet, signature))) {
      throw util.InvalidCipherTextException("invalid signature");
    }

    return packet.data!;
  }

  @override
  Widget build(BuildContext context) => Consumer<SignalingServerConnection>(
      builder: (context, conn, child) => conn.isConnected()
          ? StreamBuilder(
              stream: conn.getStream()!,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final data = snapshot.data;
                  if (data is String) {
                    return FutureBuilder(
                        future: decode(data),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            _texts += [Text(snapshot.data!)];
                          }
                          return Column(
                            children: _texts,
                          );
                        });
                  }
                }

                return Column(
                  children: _texts,
                );
              })
          : Column(
              children: _texts,
            ));
}
