import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:secrethitler/widgets/game_board.dart';

import '../game/common.dart';
import '../widgets/history_overview.dart';
import '../widgets/chat_widget.dart';
import '../game/theme.dart';
import '../client/game_client.dart';

class SecretHitlerGamePage extends StatefulWidget {
  final String gameId;
  const SecretHitlerGamePage({Key? key, required this.gameId}) : super(key: key);
  // const SecretHitlerGamePage({Key? key}) : super(key: key);

  @override
  State<SecretHitlerGamePage> createState() => _SecretHitlerGamePageState();
}

class _SecretHitlerGamePageState extends State<SecretHitlerGamePage> {
  // late String gameId;
  late GameBoard _board;
  late List<int> _susLevels;

  int numberOfPlayers = 6;

  GameState gameState = GameState.waiting;
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
  int president = 2;
  int chancellor = 4;
  int lastPresident = 1;
  int lastChancellor = 5;
  List<GameRound> history = [
    GameRound(
        president: 1, chancellor: 5, votes: [Vote.yes], votePassed: false),
    GameRound(
        president: 2,
        chancellor: 4,
        votes: [Vote.no],
        votePassed: true,
        presidentPolicies: [Side.liberal, Side.fascist, Side.fascist],
        chancellorPolicies: [Side.liberal, Side.fascist],
        policy: Side.liberal),
  ];

  void _onVote(Vote vote) {
    log('Voted ${vote.toString()}');
    GameClient.vote(vote);
  }

  void _onDiscardPolicy(int index) {
    log('Discarded $index');
    GameClient.discardPolicy(index);
  }

  void _chooseChancellor(int index) {
    log('Choosing chancellor: #$index');
    GameClient.chooseChancellor(index);
  }

  void _specialAction(int index) {
    log('Performing special action: #$index');
    GameClient.specialAction(index);
  }

  void _changeSusLevel(int index, int amount) {
    setState(() {
      _susLevels[index] += amount;
    });
  }

  @override
  void initState() {
    super.initState();


    // GameClient.getBoard().then((json) {
    //   log("got board!");
    // }, onError: (e) {
    //   log("Error while getting board: ${e.toString()}");
    // });
    _board = GameBoard(
      blueCards: 5,
      redCards: 6,
      failedElections: 1,
      numberOfPlayers: numberOfPlayers,
      gameState: gameState,
      voteCallback: _onVote,
      policyCallback: _onDiscardPolicy,
      policies: [Side.liberal, Side.fascist, Side.fascist],
    );

    _susLevels = List.filled(numberOfPlayers, 0);
  }

  @override
  Widget build(BuildContext context) {
    print('Game: id=${widget.gameId}');
    // log('Args: ${ModalRoute.of(context)?.settings.arguments}');
    return Material(
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
                        aspectRatio: 1500 / 950,
                        child: _board,
                      ),
                      Expanded(
                        child: Chat(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black87,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        numberOfPlayers,
                        (index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: AspectRatio(
                              aspectRatio: 500 / 2000,
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
    );
  }

  Widget playerCard(BuildContext context, int index) {
    if (gameState == GameState.choosingChancellor) {
      return Column(
        children: <Widget>[
          TextButton(
            onPressed: () => _chooseChancellor(index),
            child: GameTheme.current.role(roles[index]),
          ),
          Container(),
        ],
      );
    } else if (gameState == GameState.specialAction) {
      return Column(
        children: <Widget>[
          TextButton(
            onPressed: () => _specialAction(index),
            child: GameTheme.current.role(roles[index]),
          ),
          Container(),
        ],
      );
    } else if (gameState == GameState.voting) {
      return Column(
        children: <Widget>[
          GameTheme.current.role(roles[index]),
          playerVote(context, index),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          index == president ? GameTheme.current.president : Container(),
          index == chancellor
              ? GameTheme.current.chancellor
              : Container(),
          index == lastPresident
              ? GameTheme.current.lastPresident
              : Container(),
          index == lastChancellor
              ? GameTheme.current.lastChancellor
              : Container(),
          GameTheme.current.role(roles[index]),
          Container(),
        ],
      );
    }
  }

  Widget playerVote(BuildContext context, int index) {
    if (votes[index] != Vote.none) {
      return GameTheme.current.vote(votes[index]);
    } else {
      return Container();
    }
  }
}
