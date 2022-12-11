import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spychat/connect_button.dart';
import 'package:spychat/key_pem_display.dart';
import 'package:spychat/signal_form.dart';
import 'package:spychat/signaling/packet.dart';
import 'package:spychat/signaling/signaling_server_connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => SignalingServerConnection(),
      child: MaterialApp(
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
            child: Column(
              children: [
                KeyPemDisplay(),
                const SignalForm(),
                const IncomingText(),
              ],
            ),
          ),
          floatingActionButton: const ConnectButton(),
        ),
      ));
}

class IncomingText extends StatefulWidget {
  const IncomingText({super.key});

  @override
  State<StatefulWidget> createState() => _IncomingTextState();
}

class _IncomingTextState extends State<IncomingText> {
  var _texts = ["no texts"];

  StreamSubscription<dynamic>? _sub;

  void appendText(dynamic event) {
    if (event is! String) {
      return;
    }

    final json = event.substring(0, event.lastIndexOf(';'));
    final text = Packet.fromJson(jsonDecode(json));
    print("received by device");
    setState(() {
      _texts = _texts + [text.data!];
    });
  }


  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<SignalingServerConnection>(builder: (context, conn, child) {
        if (conn.isConnected()) {
          _sub = conn.getStream()!.listen(appendText);
        } else {
          _sub?.cancel();
        }

        return Column(children: _texts.map((e) => SelectableText(e)).toList());
      });
}
