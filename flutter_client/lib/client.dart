import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'game/common.dart';

class Client {
  final String endpoint;
  late final WebSocketChannel channel;

  Client(this.endpoint) {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://' + endpoint),
    );
    channel.stream.listen(
      (data) {
        log(data);
      },
      onError: (error) => log(error.toString()),
    );
  }

  Future<Map<String, dynamic>> getBoard() async {
    try {
      var response = await get(Uri.http(endpoint, 'board'));
      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body);
        } catch (e, _) {
          return Future.error('Cannot decode JSON response: ${e.toString()}');
        }
      }
      return Future.error('Cannot GET /board -> ${response.statusCode}');
    } on SocketException {
      return Future.error('Connection refused');
    }
  }

  Future vote(Vote vote) async {
    final data = {
      'vote': vote.toString(),
    };
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      var response = await post(Uri.http(endpoint, 'vote'),
          headers: headers, body: json.encode(data));
      if (response.statusCode != 200) {
        return Future.error('Cannot POST /vote -> ${response.statusCode}');
      }
    } on SocketException {
      return Future.error('Connection refused');
    }
  }

  Future discardPolicy(int index) async {
    final data = {
      'discardPolicy': index,
    };
    final headers = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await post(Uri.http(endpoint, 'discardpolicy'),
          headers: headers, body: json.encode(data));
      if (response.statusCode != 200) {
        return Future.error(
            'Cannot POST /discardpolicy -> ${response.statusCode}');
      }
    } on SocketException {
      return Future.error('Connection refused');
    }
  }

  Future chooseChancellor(int index) async {
    final data = {
      'chancellor': index,
    };
    final headers = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await post(Uri.http(endpoint, 'chooseChancellor'),
          headers: headers, body: json.encode(data));
      if (response.statusCode != 200) {
        return Future.error(
            'Cannot POST /chooseChancellor -> ${response.statusCode}');
      }
    } on SocketException {
      return Future.error('Connection refused');
    }
  }

  Future specialAction(int index) async {
    final data = {
      'specialAction': index,
    };
    final headers = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await post(Uri.http(endpoint, 'specialAction'),
          headers: headers, body: json.encode(data));
      if (response.statusCode != 200) {
        return Future.error(
            'Cannot POST /specialAction -> ${response.statusCode}');
      }
    } on SocketException {
      return Future.error('Connection refused');
    }
  }

  Future sendChatMsg(String msg) async {
    final data = {
      'msg': msg,
    };
    final headers = {
      'Content-Type': 'application/json',
    };
    try {
      var response = await post(Uri.http(endpoint, 'chat'),
          headers: headers, body: json.encode(data));
      if (response.statusCode != 200) {
        return Future.error('Cannot POST /chat -> ${response.statusCode}');
      }
    } on SocketException {
      return Future.error('Connection refused');
    }
  }
}
