import 'package:flutter/material.dart';

import 'vote_overlay.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class GameBoard extends StatelessWidget {
  final int blueCards;
  final int redCards;

  final int failedElections;

  final bool voting;
  final VoteCallback voteCallback;

  const GameBoard({
    Key? key,
    required this.blueCards,
    required this.redCards,
    required this.failedElections,
    required this.voting,
    required this.voteCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (voting) {
      return buildWithVotingOverlay(context);
    } else {
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
                  'assets/images/fixler/policy-liberal.jpg',
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
                'assets/images/fixler/policy-fascist.jpg',
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
