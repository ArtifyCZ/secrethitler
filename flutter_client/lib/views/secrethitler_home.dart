import 'package:flutter/material.dart';
import 'package:secrethitler/logger.dart';

class SecretHitlerHomePage extends StatefulWidget {

  const SecretHitlerHomePage({Key? key}) : super(key: key);

  @override
  State<SecretHitlerHomePage> createState() => _SecretHitlerHomePageState();
}

class _SecretHitlerHomePageState extends State<SecretHitlerHomePage> {
  final log = getLogger('HomePage');
  final _gameIdController = TextEditingController();

  void _joinGame(String id) {
    log.i('Joining $id');
    Navigator.pushNamed(context, "/slot/$id");
  }
  void _createGame() {
    log.i('Creating a new game');
    Navigator.pushNamed(context, "/create");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            key: const Key('btn_create'),
            onPressed: _createGame,
            child: const Text('Create game'),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('text_game_id'),
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
                key: const Key('btn_join'),
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
