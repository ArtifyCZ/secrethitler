import 'package:flutter/material.dart';
import 'package:secrethitler/client/game_client.dart';
import 'package:secrethitler/game/theme.dart';
import 'url/url_strategy.dart';

import 'views/secrethitler_home.dart';
import 'views/secrethitler_game.dart';
import 'views/secrethitler_login.dart';

void main() {
  GameClient.init("localhost:8000");
  usePathUrlStrategy();
  runApp(const SecretHitlerApp());
}

class SecretHitlerApp extends StatelessWidget {

  const SecretHitlerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GameTheme.current.title,
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      routes: {
        '/': (context) => SecretHitlerHomePage(title: GameTheme.current.title),
        '/slot/': (context) => SecretHitlerGamePage(),
        '/login/': (context) => SecretHitlerLoginPage(),
      },
      initialRoute: '/login/',
    );
  }
}
