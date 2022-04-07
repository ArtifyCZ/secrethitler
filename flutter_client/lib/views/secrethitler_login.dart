import 'dart:developer';
import 'package:flutter/material.dart';
import '../client/game_client.dart';

class SecretHitlerLoginPage extends StatelessWidget {
  SecretHitlerLoginPage({Key? key}) : super(key: key);

  final _usernameController = TextEditingController();

  void _login (BuildContext context, String username) {
    GameClient.anonymousLogin(username).then((value) {
      if (value) {
        Navigator.pushNamed(context, "/");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        height: size.height,
        width: size.width,
        color: Colors.grey[900],
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter your username',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                onSubmitted: (value) => _login(context, value),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _login(context, _usernameController.text);
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

