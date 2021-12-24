import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  final int blueCards;
  final int redCards;

  final int failedElections;

  const GameBoard({Key? key,required this.blueCards, required this.redCards, required this.failedElections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.blue,
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.red,
          ),
        )
      ],
    );
  }
}
