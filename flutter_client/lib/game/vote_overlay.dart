import 'package:flutter/material.dart';

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
      color: Colors.black.withAlpha(80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(40),
            child: ElevatedButton(
              onPressed: () {
                onVote(Vote.yes);
              },
              child: Image.asset('assets/images/fixler/vote-yes.jpg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: ElevatedButton(
              onPressed: () {
                onVote(Vote.no);
              },
              child: Image.asset('assets/images/fixler/vote-no.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}
