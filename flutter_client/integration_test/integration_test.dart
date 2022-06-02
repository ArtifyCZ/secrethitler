import 'dart:math';
import 'dart:io';

import 'package:secrethitler/logger.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';

import 'package:secrethitler/main.dart';
import 'package:secrethitler/client/game_client.dart';

void main() {
  testWidgets('Login and create a new slot', (WidgetTester tester) async {
    final log = getLogger('Tester');

    log.i('Starting test...');

    String host;
    int port;

    host = Platform.environment['HOST'] ?? "127.0.0.1";
    port = int.tryParse(Platform.environment['PORT'] ?? "") ?? 8000;

    GameClient.init(host, port);


    log.i('Starting app...');

    // Build our app and trigger a frame.
    await tester.pumpWidget(const SecretHitlerApp());

    String username = getRandomUsername(8);

    // Expect login form
    {
      var btnLogin = find.byKey(const Key('btn_login'));
      var textUsername = find.byKey(const Key('text_username'));
      expect(textUsername, findsOneWidget);
      expect(btnLogin, findsOneWidget);

      log.i('Authenticating...');
      await tester.enterText(textUsername, username);
      await tester.tap(btnLogin);
      await tester.pumpAndSettle();
    }

    expect(GameClient.isAuthenticated(), equals(true));

    expect(find.byKey(const Key('error_box')), findsNothing);

    // Expect home page
    {
      var btnCreate = find.byKey(const Key('btn_create'));
      var textGameId = find.byKey(const Key('text_game_id'));
      var btnJoin = find.byKey(const Key('btn_join'));
      expect(btnCreate, findsOneWidget);
      expect(textGameId, findsOneWidget);
      expect(btnJoin, findsOneWidget);

      await tester.tap(btnCreate);
      await tester.pumpAndSettle();
    }

    // Expect create game page
    {
      var btnCreate = find.byKey(const Key('btn_create_slot'));
      expect(btnCreate, findsOneWidget);

      log.i('Creating a new slot...');
      await tester.tap(btnCreate);
      await tester.pumpAndSettle();
    }

    // Expect game page
    {
      var gameBoard = find.byKey(const Key('game_board'));
      expect(gameBoard, findsOneWidget);
    }

    log.i("Test successful");
  });
}


String getRandomUsername(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyz';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))
  ));
}
