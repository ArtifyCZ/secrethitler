import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:secrethitler/main.dart';

void main() {

  testWidgets('Login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SecretHitlerApp());

    // Expect login form
    var btnLogin = find.byKey(const Key('btn_login'));
    var textUsername = find.byKey(const Key('text_username'));
    expect(textUsername, findsOneWidget);
    expect(btnLogin, findsOneWidget);
  });
}

