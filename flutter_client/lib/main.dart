import 'package:flutter/material.dart';

import 'secrethitler_home.dart';
import 'secrethitler_game.dart';

void main() {
  runApp(const SecretHitlerApp());
}

class SecretHitlerApp extends StatelessWidget {
  static const String title = 'Secret Hitler';
  const SecretHitlerApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SecretHitlerGamePage(title: title),
    );
  }
}

