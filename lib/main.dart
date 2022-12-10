import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spychat/key_pem_display.dart';
import 'package:spychat/connect_button.dart';
import 'package:spychat/signaling/encapsulation.dart';
import 'package:spychat/signaling/signaling_server_connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
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
                children: [KeyPemDisplay(), const SignalForm()],
              ),
            ),
            floatingActionButton: const ConnectButton(),
          ),
        ));
  }
}

class SignalForm extends StatefulWidget {
  const SignalForm({super.key});

  @override
  State<SignalForm> createState() => _SignalFormState();
}

class _SignalFormState extends State<SignalForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _textFieldController,
            decoration: const InputDecoration(
              hintText: "Enter peer's public key",
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Consumer<SignalingServerConnection>(
                builder: (context, conn, child) {
              return ElevatedButton(
                onPressed: conn.isConnected()
                    ? () async {
                        if (_formKey.currentState!.validate()) {
                          conn.getSink()!.add(await encapsulatePacket(
                              _textFieldController.text, "test data"));
                          _textFieldController.clear();
                        }
                      }
                    : null,
                child: const Text('Signal peer'),
              );
            }),
          ),
        ],
      ),
    );
  }
}
