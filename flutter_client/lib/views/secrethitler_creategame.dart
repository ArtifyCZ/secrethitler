import 'package:flutter/material.dart';
import 'package:secrethitler/logger.dart';
import '../client/game_client.dart';

class SecretHitlerCreateGamePage extends StatefulWidget {
  const SecretHitlerCreateGamePage({Key? key}) : super(key: key);

  @override
  State<SecretHitlerCreateGamePage> createState() =>
      _SecretHitlerCreateGamePageState();
}

class _SecretHitlerCreateGamePageState extends State<SecretHitlerCreateGamePage> {
  final log = getLogger('CreateGamePage');
  final _slotNameController = TextEditingController();

  void _createGame() {
    log.i('Creating a new game');
    GameClient.createGame().then((uuid) {
      if (uuid != null) {
        Navigator.pushNamed(context, "/slot/$uuid");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
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
            key: const Key('btn_create_slot'),
            onPressed: _createGame,
            child: const Text("Create game"),
          ),
        ],
      ),
    );
  }
}
