import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:secrethitler/game/game_board.dart';

import 'game/common.dart';
import 'game/theme.dart';
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

  int numberOfPlayers = 6;

  GameState _gameState = GameState.voting;

  List<Vote> votes = [
    Vote.none,
    Vote.unknown,
    Vote.none,
    Vote.unknown,
    Vote.unknown,
    Vote.unknown
  ];
  List<Role> roles = [
    Role.liberal,
    Role.fascist,
    Role.hitler,
    Role.liberal,
    Role.fascist,
    Role.liberal
  ];

  void _onVote(Vote vote) {
    log('Voted ${vote.toString()}');
    _client.vote(vote).onError((error, stackTrace) {
      log("Error while voting: ${error.toString()}");
    });
  }

  void _onDiscardPolicy(int index) {
    log('Discarded $index');
    _client.discardPolicy(index).onError((error, stackTrace) {
      log("Error while discarding policy: ${error.toString()}");
    });
  }

  @override
  void initState() {
    super.initState();

    _client = Client('localhost:5001');
    _client.getBoard().then((json) {
      log("got board!");
    }, onError: (e) {
      log("Error while getting board: ${e.toString()}");
    });
    _board = GameBoard(
      blueCards: 2,
      redCards: 3,
      failedElections: 1,
      gameState: _gameState,
      voteCallback: _onVote,
      policyCallback: _onDiscardPolicy,
      policies: [Side.liberal, Side.fascist, Side.fascist],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  return playerCard(context, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget playerCard(BuildContext context, int index) {
    return SizedBox(
      width: 100,
      height: 160,
      child: Image.asset(
        GameTheme.fixler.role(roles[index]),
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
