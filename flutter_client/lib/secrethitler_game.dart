import 'package:flutter/material.dart';
import 'package:secrethitler/game/game_board.dart';

class SecretHitlerGamePage extends StatefulWidget {
  const SecretHitlerGamePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SecretHitlerGamePage> createState() => _SecretHitlerGamePageState();
}

class _SecretHitlerGamePageState extends State<SecretHitlerGamePage> {
  static const TextStyle chatTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    decoration: TextDecoration.none,
  );

  int _blueCards = 0;
  int _redCards = 0;
  int _failedElections = 0;

  @override
  Widget build(BuildContext context) {
    // board
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.grey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 2 / 1,
                  child: GameBoard(
                    blueCards: _blueCards,
                    redCards: _redCards,
                    failedElections: _failedElections,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          // chat
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const Text("Chat", style: chatTextStyle);
              },
            ),
          )
        ],
      ),
    );
  }
}
