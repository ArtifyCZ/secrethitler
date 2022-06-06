import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class HttpClient {
  final String endpoint;
  late final WebSocketChannel channel;

  String? token;

  HttpClient(this.endpoint) {
    // channel = WebSocketChannel.connect(
    //   Uri.parse('wss://' + endpoint),
    // );
    // channel.stream.listen(
    //   (data) {
    //     log(data);
    //   },
    //   onError: (error) => log(error.toString()),
    // );
  }

  Future<Map<String, dynamic>> getData(String path) async {
    final headers = {
      'Authorization': token ?? "None",
    };
    try {
      var response = await http.get(Uri.http(endpoint, path), headers: headers);
      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body);
        } catch (e, _) {
          return Future.error('Cannot decode JSON response: ${e.toString()}');
        }
      }
      return Future.error('Cannot GET /$path -> ${response.statusCode}');
    } on SocketException {
      return Future.error('Connection refused');
    }
  }

  Future<Map<String, dynamic>?> postData(
      String path, Map<String, dynamic> data) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': token ?? "None",
    };
    try {
      var response = await http.post(Uri.http(endpoint, path),
          headers: headers, body: json.encode(data));
      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body);
        } catch (e, _) {
          return Future.error('Cannot decode JSON response: ${e.toString()}');
        }
      } else {
        return Future.error(
            'Cannot POST /$path -> ${response.statusCode} (${response.reasonPhrase})');
      }
    } on SocketException {
      return Future.error('Connection refused');
    }
  }

  Future<void> deleteData(String path) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': token ?? "None",
    };
    try {
      var response = await http.delete(Uri.http(endpoint, path), headers: headers);
      if (response.statusCode != 200) {
        return Future.error(
            'Cannot DELETE /$path -> ${response.statusCode} (${response.reasonPhrase})');
      }
    } on SocketException {
      return Future.error('Connection refused');
    }
  }
}
