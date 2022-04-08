import 'dart:developer';
import 'package:flutter/material.dart';
import '../client/game_client.dart';

class SecretHitlerLoginPage extends StatefulWidget {
  SecretHitlerLoginPage({Key? key}) : super(key: key);

  @override
  State<SecretHitlerLoginPage> createState() => _SecretHitlerLoginPageState();
}

class _SecretHitlerLoginPageState extends State<SecretHitlerLoginPage> {
  final _usernameController = TextEditingController();
  String _error = "";

  void _login (BuildContext context, String username) {
    GameClient.anonymousLogin(username).then((value) {
      if (value) {
        Navigator.pushNamed(context, "/");
      } else {
        setState(() {
          _error = "Error while logging in";
        });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            errorBox(context),
            Row(
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
          ],
        ),
      ),
    );
  }


  Widget errorBox (BuildContext context) {
    if (_error != "") {
      return Container(
        color: Colors.red,
        padding: const EdgeInsets.all(5),
        child: Text(_error),
      );
    } else {
      return Container();
    }
  }
}

