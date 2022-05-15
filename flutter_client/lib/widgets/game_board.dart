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
  final int numberOfPlayers;
  final GameState gameState;
  final VoteCallback voteCallback;
  final PolicyCallback policyCallback;
  final List<Side>? policies;

  const GameBoard({
    Key? key,
    required this.blueCards,
    required this.redCards,
    required this.failedElections,
    required this.numberOfPlayers,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GameTheme.current.liberalBoard,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: constraints.minWidth * 0.15,
                        height: constraints.minHeight / 2,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: constraints.minHeight / 4,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: blueCards,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                GameTheme.current.policy(Side.liberal),
                            separatorBuilder: (context, index) =>
                                SizedBox(width: constraints.minWidth * 0.038),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  GameTheme.current.fascistBoard(numberOfPlayers),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: constraints.minWidth * 0.074,
                        height: constraints.minHeight / 2,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: constraints.minHeight / 4,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: redCards,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                GameTheme.current.policy(Side.fascist),
                            separatorBuilder: (context, index) =>
                                SizedBox(width: constraints.minWidth * 0.038),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
