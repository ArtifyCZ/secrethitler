import 'package:flutter/material.dart';
import 'dart:developer';

class SecretHitlerHomePage extends StatefulWidget {
  final String title;
  const SecretHitlerHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<SecretHitlerHomePage> createState() => _SecretHitlerHomePageState();
}

class _SecretHitlerHomePageState extends State<SecretHitlerHomePage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _gameIdController = TextEditingController();

  void _joinGame(String id) {
    log('Joining $id');
    Navigator.pushNamed(context, "/slot/", arguments: id);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        height: size.height,
        width: size.width,
        color: Colors.grey[900],
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _gameIdController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter game ID',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                onSubmitted: _joinGame,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _joinGame(_gameIdController.text);
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
    _gameIdController.dispose();
    super.dispose();
  }
}
