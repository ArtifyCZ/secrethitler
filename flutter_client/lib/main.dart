import 'package:flutter/material.dart';
import 'package:secrethitler/game/theme.dart';

import 'secrethitler_home.dart';
import 'secrethitler_game.dart';

void main() {
  runApp(const SecretHitlerApp());
}

class SecretHitlerApp extends StatelessWidget {

  const SecretHitlerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GameTheme.currentTheme.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => SecretHitlerHomePage(title: GameTheme.currentTheme.title),
        '/game/': (context) => SecretHitlerGamePage(),
      },
      initialRoute: '/game/',
    );
  }
}
