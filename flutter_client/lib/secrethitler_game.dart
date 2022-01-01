import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:secrethitler/game/game_board.dart';

import 'game/common.dart';
import 'game/history_overview.dart';
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
  late List<int> _susLevels;

  int numberOfPlayers = 6;

  GameState _gameState = GameState.choosingChancellor;
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
  int _chancellor = 0;
  int _president = 0;
  int _lastChancellor = 0;
  int _lastPresident = 0;
  List<GameRound> history = [
    GameRound(president: 1, chancellor: 5, votes: [Vote.yes], elected: false),
    GameRound(president: 2, chancellor: 4, votes: [Vote.no], elected: true),
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

  void _changeSusLevel(int index, int amount) {
    setState(() {
      _susLevels[index] += amount;
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

    _susLevels = List.filled(numberOfPlayers, 0);
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
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 2 / 1,
                          child: _board,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return const Text("Chat",
                                        style: chatTextStyle);
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
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: AspectRatio(
                                aspectRatio: 600 / 2000,
                                child: playerCard(context, index),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: HistoryOverview(history: history),
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
          TextButton(
            onPressed: () => _chooseChancellor(index),
            child: Image.asset(GameTheme.currentTheme.role(roles[index])),
          ),
          Container(),
        ],
      );
    } else if (_gameState == GameState.specialAction) {
      return Column(
        children: <Widget>[
          TextButton(
            onPressed: () => _specialAction(index),
            child: Image.asset(GameTheme.currentTheme.role(roles[index])),
          ),
          Container(),
        ],
      );
    } else if (_gameState == GameState.voting) {
      return Column(
        children: <Widget>[
          Image.asset(GameTheme.currentTheme.role(roles[index])),
          playerVote(context, index),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Image.asset(GameTheme.currentTheme.role(roles[index])),
          Container(),
        ],
      );
    }
  }

  Widget playerVote(BuildContext context, int index) {
    if (votes[index] != Vote.none) {
      return Image.asset(GameTheme.currentTheme.vote(votes[index]));
    } else {
      return Container();
    }
  }
}
