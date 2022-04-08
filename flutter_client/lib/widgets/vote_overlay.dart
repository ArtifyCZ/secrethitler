import 'package:flutter/material.dart';
import 'package:secrethitler/game/theme.dart';

import '../game/common.dart';

typedef VoteCallback = Function(Vote vote);

class VoteOverlay extends StatelessWidget {
  final VoteCallback onVote;

  const VoteOverlay({
    Key? key,
    required this.onVote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(90),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(40),
            child: TextButton(
              onPressed: () {
                onVote(Vote.yes);
              },
              child: GameTheme.current.vote(Vote.yes),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: TextButton(
              onPressed: () {
                onVote(Vote.no);
              },
              child: GameTheme.current.vote(Vote.no),
            ),
          ),
        ],
      ),
    );
  }
}
