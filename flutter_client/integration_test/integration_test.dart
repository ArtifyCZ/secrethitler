import 'package:secrethitler/logger.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter/material.dart';
import 'package:secrethitler/main.dart';
import 'package:secrethitler/client/game_client.dart';

void main() {
  final log = getLogger('Tester');

  log.i('Starting test...');

  GameClient.init("127.0.0.1:8000");

  testWidgets('Login and create a new slot', (WidgetTester tester) async {
    log.i('Starting app...');
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SecretHitlerApp());

    const String username = 'Flutter Test';

    // Expect login form
    var btnLogin = find.byKey(const Key('btn_login'));
    var textUsername = find.byKey(const Key('text_username'));
    expect(textUsername, findsOneWidget);
    expect(btnLogin, findsOneWidget);

    log.i('Authenticating...');
    await tester.enterText(textUsername, username);
    await tester.tap(btnLogin);
    await tester.pumpAndSettle();

    expect(GameClient.isAuthenticated(), equals(true));

    expect(find.byKey(const Key('error_box')), findsNothing);


    log.i('Creating a new slot...');
    // Expect home page
    var btnCreate = find.byKey(const Key('btn_create'));
    var textGameId = find.byKey(const Key('text_game_id'));
    var btnJoin = find.byKey(const Key('btn_join'));
    expect(btnCreate, findsOneWidget);
    expect(textGameId, findsOneWidget);
    expect(btnJoin, findsOneWidget);

    await tester.tap(btnCreate);
    await tester.pumpAndSettle();
  });
}
