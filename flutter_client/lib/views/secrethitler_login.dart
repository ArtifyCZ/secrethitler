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
  Future<bool>? loginFuture;

  void _login(BuildContext context, String username) {
    setState(() {
      loginFuture = GameClient.anonymousLogin(username);
    });
  }

  @override
  void initState() {
    super.initState();
    loginFuture = null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<bool>(
            future: loginFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Container();
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    if (snapshot.data!) {
                      Navigator.pushNamed(context, "/");
                      return const Text('Login successful');
                    } else {
                      return Container(
                        color: Colors.red,
                        padding: const EdgeInsets.all(5),
                        child: const Text('Error while logging in'),
                      );
                    }
                  } else {
                    return Text('No data');
                  }
              }
            },
          ),
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
    );
  }
}
