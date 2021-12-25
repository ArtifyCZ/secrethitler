import 'package:flutter/material.dart';
import 'package:secrethitler/game/game_board.dart';

import 'client.dart';

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

  late GameBoard _board;
  late Client _client;

  @override
  void initState(){
    super.initState();

    // _client = Client('ip:port');
    // _client.getBoard().then((board) {
    //   print("got board!");
    //   _board = board;
    // });
    _board = GameBoard(blueCards: 2, redCards: 3, failedElections: 1);
  }

  @override
  Widget build(BuildContext context) {
    int numberOfPlayers = 6;
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
                  child: _board,
                ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: numberOfPlayers,
                      itemBuilder: (context, index) {
                        return const SizedBox(
                          width: 50,
                          height: 80,
                          child: Card(
                            color: Colors.grey,
                            child: Text('Player'),
                          ),
                        );
                      },
                    ),
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
