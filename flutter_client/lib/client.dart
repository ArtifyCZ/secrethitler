import 'dart:convert';
import 'dart:developer';
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
      onError: (error) => log(error),
    );
  }

  Future<Map<String, dynamic>> getBoard() async {
    var response = await get(Uri.http(endpoint, 'board'));
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e, _) {
        return Future.error('Cannot decode JSON response: ${e.toString()}');
      }
    }
    return Future.error('Cannot GET /board -> ${response.statusCode}');
  }

  Future vote(Vote vote) async {
    final data = {
      'vote': vote.toString(),
    };
    final headers = {
      'Content-Type': 'application/json',
    };
    var response = await post(Uri.http(endpoint, 'vote'),
        headers: headers, body: json.encode(data));
    if (response.statusCode != 200) {
      return Future.error('Cannot POST /vote -> ${response.statusCode}');
    }
  }
  Future discardPolicy(int index) async {
    final data = {
      'discardPolicy': index,
    };
    final headers = {
      'Content-Type': 'application/json',
    };
    var response = await post(Uri.http(endpoint, 'discardpolicy'),
        headers: headers, body: json.encode(data));
    if (response.statusCode != 200) {
      return Future.error('Cannot POST /discardpolicy -> ${response.statusCode}');
    }
  }
}
