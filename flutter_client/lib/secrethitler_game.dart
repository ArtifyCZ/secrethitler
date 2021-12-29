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

  GameState _gameState = GameState.waiting;
  List<Vote> votes = [
    Vote.none,
    Vote.unknown,
    Vote.none,
    Vote.unknown,
    Vote.yes,
    Vote.no
  ];
  List<Role> roles = [
    Role.liberal,
    Role.fascist,
    Role.hitler,
    Role.liberal,
    Role.liberal,
    Role.fascist,
  ];
  int _lastChancellor = 0;
  int _lastPresident = 0;

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

  void _chooseChancellor(int index) {
    log('Choosing chancellor: #$index');
    _client.chooseChancellor(index);
  }

  void _specialAction(int index) {
    log('Performing special action: #$index');
    _client.specialAction(index);
  }

  void _sendChatMsg(String msg) {
    log('Sending chat message: "$msg"');
    _client.sendChatMsg(msg);
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

    return Material(
      child: Container(
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
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const Text("Chat", style: chatTextStyle);
                            },
                          ),
                        ),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Type something',
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
                          onSubmitted: _sendChatMsg,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    numberOfPlayers,
                    (index) {
                      return AspectRatio(
                        aspectRatio: 600 / 2000,
                        child: playerCard(context, index),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playerCard(BuildContext context, int index) {
    if (_gameState == GameState.choosingChancellor) {
      return Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _chooseChancellor(index),
            child: Image.asset(
              GameTheme.fixler.role(roles[index]),
              fit: BoxFit.scaleDown,
            ),
          ),
          Container(),
        ],
      );
    } else if (_gameState == GameState.specialAction) {
      return Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _specialAction(index),
            child: Image.asset(
              GameTheme.fixler.role(roles[index]),
              fit: BoxFit.scaleDown,
            ),
          ),
          Container(),
        ],
      );
    } else if (_gameState == GameState.voting) {
      return Column(
        children: <Widget>[
          Image.asset(
            GameTheme.fixler.role(roles[index]),
            fit: BoxFit.scaleDown,
          ),
          playerVote(context, index),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Image.asset(
            GameTheme.fixler.role(roles[index]),
            fit: BoxFit.scaleDown,
          ),
          Container(),
        ],
      );
    }
  }

  Widget playerVote(BuildContext context, int index) {
    if (votes[index] != Vote.none) {
      return Image.asset(GameTheme.fixler.vote(votes[index]),
          fit: BoxFit.scaleDown);
    } else {
      return Container();
    }
  }
}
