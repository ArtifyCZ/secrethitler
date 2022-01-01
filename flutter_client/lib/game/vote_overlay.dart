import 'package:flutter/material.dart';
import 'package:secrethitler/game/theme.dart';

import 'common.dart';

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
              child: Image.asset(GameTheme.currentTheme.vote(Vote.yes)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: TextButton(
              onPressed: () {
                onVote(Vote.no);
              },
              child: Image.asset(GameTheme.currentTheme.vote(Vote.no)),
            ),
          ),
        ],
      ),
    );
  }
}
