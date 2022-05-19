import 'package:secrethitler/logger.dart';

import 'package:flutter/material.dart';
import 'package:secrethitler/client/game_client.dart';
import 'package:secrethitler/game/theme.dart';

import 'views/secrethitler_home.dart';
import 'views/secrethitler_game.dart';
import 'views/secrethitler_login.dart';

void main() {
  GameClient.init("localhost:8000");
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
      initialRoute: '/login/',
      // routes: {
      //   '/': (context) => SecretHitlerHomePage(),
      //   '/slot/': (context) => SecretHitlerGamePage(),
      //   '/login/': (context) => SecretHitlerLoginPage(),
      // },
      onGenerateRoute: (settings) {
        Uri uri = Uri.parse(settings.name ?? '');
        var path = uri.pathSegments;

        var routeSettings = RouteSettings(name: settings.name);

        if (path.isEmpty) {
          return MaterialPageRoute(
            builder: (context) => const SecretHitlerHomePage(),
            settings: routeSettings,
          );
        }

        switch (path[0]) {
          case 'login':
            return MaterialPageRoute(
              builder: (context) => SecretHitlerLoginPage(),
              settings: routeSettings,
            );
          case 'slot':
            return MaterialPageRoute(
              builder: (context) =>
                  SecretHitlerGamePage(gameId: path.length >= 2 ? path[1] : ''),
              settings: routeSettings,
            );
          case 'create':
            return MaterialPageRoute(
              builder: (context) => SecretHitlerLoginPage(),
              settings: routeSettings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const SelectableText('Invalid path'),
              settings: routeSettings,
            );
        }
      },
      onGenerateTitle: (context) => GameTheme.current.title,
    );
  }
}
