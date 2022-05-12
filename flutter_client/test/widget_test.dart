// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secrethitler/client/game_client.dart';

import 'package:secrethitler/main.dart';

void main() {
  testWidgets('Login and create a new slot', (WidgetTester tester) async {
    GameClient.init("127.0.0.1:8000");
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SecretHitlerApp());

    // Expect login form
    var btnLogin = find.byKey(const Key('btn_login'));
    var textUsername = find.byKey(const Key('text_username'));
    expect(textUsername, findsOneWidget);
    expect(btnLogin, findsOneWidget);

    await tester.enterText(textUsername, 'My Name');
    await tester.tap(btnLogin);
    await tester.pumpAndSettle();

    expect(GameClient.authenticated, true);

    expect(find.byKey(const Key('error_box')), findsNothing);


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
