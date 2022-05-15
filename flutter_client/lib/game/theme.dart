
import 'package:flutter/material.dart';
import 'common.dart';
import 'themes/fixler_theme.dart';
import 'themes/secrethitler_theme.dart';
import 'themes/secrethitlersvg_theme.dart';

abstract class GameTheme {
  // Texts:
  abstract String title;
  abstract String presidentName;
  abstract String chancellorName;
  abstract String liberalName;
  abstract String fascistName;

  // Images:
  abstract Widget president;
  abstract Widget chancellor;
  abstract Widget lastPresident;
  abstract Widget lastChancellor;
  abstract Widget liberalBoard;
  Widget fascistBoard(int numberOfPlayers);
  Widget vote(Vote v);
  Widget role(Role r);
  Widget side(Side s);
  Widget policy(Side s);

  static final FixlerTheme _fixler = FixlerTheme();
  // static final SecretHitlerTheme _secretHitler = SecretHitlerTheme();
  static final SecretHitlerSvgTheme _secretHitlerSvg = SecretHitlerSvgTheme();

  static final GameTheme current = _fixler;
}

