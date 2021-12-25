import 'dart:convert';
import 'package:http/http.dart';
import 'package:secrethitler/game/game_board.dart';

class Client {
  final String endpoint;

  Client(this.endpoint);

  Future<Map<String, dynamic>> getBoard() async {
    var response = await get(Uri.http(endpoint, 'board'));
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e, _){
        return Future.error(e);
      }
    }
    return Future.error('Cannot GET /board -> ${response.statusCode}');
  }



  Future vote(bool yes) async {
    final data = {
      'vote': yes,
    };
    final headers = {
      'Content-Type': 'application/json'
    };
    await post(Uri.http(endpoint, 'vote'), headers: headers, body: json.encode(data));
  }
}
