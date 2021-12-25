import 'package:flutter/material.dart';

typedef VoteCallback = Function(bool yes);

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
                onVote(true);
              },
              child: Image.asset('assets/images/fixler/vote-yes.jpg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: ElevatedButton(
              onPressed: () {
                onVote(false);
              },
              child: Image.asset('assets/images/fixler/vote-no.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}
