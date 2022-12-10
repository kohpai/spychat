import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spychat/signaling/encapsulation.dart';
import 'package:spychat/signaling/signaling_server_connection.dart';

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
  Widget build(BuildContext context) => Form(
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
