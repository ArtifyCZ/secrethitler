import 'package:flutter/material.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SecretHitlerGamePage(title: 'Secret Hitler'),
    );
  }
}

