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
      loginFuture?.then((result) {
        if (result == true) {
          Navigator.pushNamed(context, "/");
        }
      });
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
                      return Container(
                        color: Colors.green,
                        padding: const EdgeInsets.all(5),
                        child: const Text('Login successful'),
                      );
                    } else {
                      return Container(
                        key: const Key('error_box'),
                        color: Colors.red,
                        padding: const EdgeInsets.all(5),
                        child: const Text('Error while logging in'),
                      );
                    }
                  } else {
                    return const Text('No data');
                  }
              }
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('text_username'),
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your username',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  onSubmitted: (value) => _login(context, value),
                ),
              ),
              ElevatedButton(
                key: const Key('btn_login'),
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
