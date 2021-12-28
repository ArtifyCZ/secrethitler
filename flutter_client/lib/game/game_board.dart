import 'package:flutter/material.dart';
import 'package:secrethitler/game/common.dart';
import 'package:secrethitler/game/theme.dart';

import 'vote_overlay.dart';
import 'policy_overlay.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class GameBoard extends StatelessWidget {
  final int blueCards;
  final int redCards;
  final int failedElections;
  final GameState gameState;
  final VoteCallback voteCallback;
  final PolicyCallback policyCallback;
  final List<Side>? policies;

  const GameBoard({
    Key? key,
    required this.blueCards,
    required this.redCards,
    required this.failedElections,
    required this.gameState,
    required this.voteCallback,
    required this.policyCallback,
    this.policies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (gameState) {
      case GameState.voting:
        return buildWithVotingOverlay(context);
      case GameState.discardingPolicy:
        return buildWithPolicyOverlay(context);
      default:
        return buildBoard(context);
    }
  }

  Widget buildWithVotingOverlay(BuildContext context) {
    return Stack(
      children: [
        buildBoard(context),
        VoteOverlay(onVote: voteCallback),
      ],
    );
  }

  Widget buildWithPolicyOverlay(BuildContext context) {
    return Stack(
      children: [
        buildBoard(context),
        PolicyOverlay(onSelectPolicy: policyCallback, policies: policies!),
      ],
    );
  }

  Widget buildBoard(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.blue,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: blueCards,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Image.asset(
                  GameTheme.fixler.policy(Side.liberal),
                  fit: BoxFit.cover),
              separatorBuilder: (context, index) => const SizedBox(width: 20),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.red,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: redCards,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Image.asset(
                GameTheme.fixler.policy(Side.fascist),
                fit: BoxFit.cover,
              ),
              separatorBuilder: (context, index) => const SizedBox(width: 20),
            ),
          ),
        )
      ],
    );
  }

  void _showOverlay(BuildContext context) async {
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return VoteOverlay(onVote: voteCallback);
    });

    Overlay.of(context)?.insert(overlayEntry);
  }
}
