import 'package:flutter/material.dart';
import 'dart:developer';

class SecretHitlerHomePage extends StatefulWidget {
  const SecretHitlerHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SecretHitlerHomePage> createState() => _SecretHitlerHomePageState();
}

class _SecretHitlerHomePageState extends State<SecretHitlerHomePage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _myController = TextEditingController();

  void _joinGame(String id) {
    log('Joining $id');
    Navigator.pushNamed(context, "/game/", arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter game ID:',
            ),
            TextField(
              controller: _myController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter game id',
              ),
              onSubmitted: _joinGame,
            ),
            ElevatedButton(
              onPressed: () {
                _joinGame(_myController.text);
              },
              child: const Text("Join game"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    super.dispose();
  }
}
