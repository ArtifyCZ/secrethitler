import 'package:flutter/material.dart';
import 'dart:developer';
import '../client/game_client.dart';

class Chat extends StatelessWidget {
  Chat({
    Key? key,
  }) : super(key: key);

  static const TextStyle chatTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
  );

  final _msgController = TextEditingController();

  void _sendChatMsg(String msg) {
    log('Sending chat message: "$msg"');
    GameClient.sendChatMsg(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 30,
            itemBuilder: (context, index) {
              return Text("Chat $index", style: chatTextStyle);
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _msgController,
                decoration: const InputDecoration(
                  hintText: 'Type something',
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
                onSubmitted: _sendChatMsg,
              ),
            ),
            ElevatedButton(
              onPressed: () => _sendChatMsg(_msgController.text),
              child: const Text('Send'),
            ),
          ],
        ),
      ],
    );
  }
}
