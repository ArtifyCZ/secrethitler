import 'package:flutter/material.dart';

class SecretHitlerHomePage extends StatelessWidget {
  final String title;
  const SecretHitlerHomePage({Key? key, required this.title}) : super(key: key);

  void _joinGame(BuildContext context, String gameId) {
    Navigator.of(context).pushNamed("/slot/");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        height: size.height,
        width: size.width,
        color: Colors.grey[900],
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Game ID',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                onSubmitted: (gameId) => _joinGame(context,gameId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
