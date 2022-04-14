import 'package:flutter/material.dart';
import 'dart:developer';

class SecretHitlerCreateGamePage extends StatefulWidget {
  const SecretHitlerCreateGamePage({Key? key}) : super(key: key);

  @override
  State<SecretHitlerCreateGamePage> createState() =>
      _SecretHitlerCreateGamePageState();
}

class _SecretHitlerCreateGamePageState
    extends State<SecretHitlerCreateGamePage> {
  final _slotNameController = TextEditingController();

  void _createGame() {
    log('Creating a new game');
    //TODO: GameClient.createGame();
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
          Expanded(
            child: TextField(
              controller: _slotNameController,
              decoration: const InputDecoration(
                hintText: 'Enter game name',
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
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _createGame();
            },
            child: const Text("Create game"),
          ),
        ],
      ),
    );
  }
}
