import 'dart:developer';

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

  //states
  bool _voting = true;

  void _onVote(bool yes) {
    log('Voted ${yes ? "yes" : "no"}');
  }

  @override
  void initState() {
    super.initState();

    // _client = Client('ip:port');
    // _client.getBoard().then((board) {
    //   print("got board!");
    // });
    _board = GameBoard(
      blueCards: 2,
      redCards: 3,
      failedElections: 1,
      voting: _voting,
      voteCallback: _onVote,
    );
  }

  @override
  Widget build(BuildContext context) {
    int numberOfPlayers = 10;
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      color: Colors.grey[900],
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 2 / 1,
                  child: _board,
                  // chat
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const Text("Chat", style: chatTextStyle);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: numberOfPlayers,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 100,
                    height: 160,
                    child: Image.asset(
                      'assets/images/fixler/role-hitler.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
