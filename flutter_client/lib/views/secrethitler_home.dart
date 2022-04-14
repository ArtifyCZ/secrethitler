import 'package:flutter/material.dart';
import 'dart:developer';

class SecretHitlerHomePage extends StatefulWidget {

  const SecretHitlerHomePage({Key? key}) : super(key: key);

  @override
  State<SecretHitlerHomePage> createState() => _SecretHitlerHomePageState();
}

class _SecretHitlerHomePageState extends State<SecretHitlerHomePage> {
  final _gameIdController = TextEditingController();

  void _joinGame(String id) {
    log('Joining $id');
    Navigator.pushNamed(context, "/slot/$id");
  }
  void _createGame() {
    log('Creating a new game');
    Navigator.pushNamed(context, "/create");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _createGame,
            child: const Text('Create game'),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _gameIdController,
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
        ],
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