import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  final int blueCards;
  final int redCards;

  final int failedElections;

  const GameBoard(
      {Key? key,
      required this.blueCards,
      required this.redCards,
      required this.failedElections})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.blue,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: blueCards,
              itemBuilder: (context, index) => Card(color: Colors.blue[700]),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.red,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: redCards,
              itemBuilder: (context, index) => Card(color: Colors.red[700]),
            ),
          ),
        )
      ],
    );
  }
}
