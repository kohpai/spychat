import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spychat/signaling/signaling_server_connection.dart';

class ConnectButton extends StatelessWidget {
  const ConnectButton({super.key});

  @override
  Widget build(BuildContext context) =>
      Consumer<SignalingServerConnection>(builder: (context, conn, child) =>
          FloatingActionButton(
            onPressed: () async {
              if (conn.isConnected()) {
                conn.disconnect();
              } else {
                await conn.connect();
              }
            },
            child: Icon(
                conn.isConnected() ? Icons.cloud_done : Icons.cloud_off),
          )
      );
}