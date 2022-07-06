import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:secrethitler/logger.dart';

final _log = getLogger('HttpClient');

class MyHttpClient {
  final String _endpoint;

  String? _token;

  MyHttpClient(this._endpoint);

  String getToken() {
    return _token ?? "None";
  }
  void setToken(String token) {
    _token = token;
  }
  void clearToken() {
    _token = null;
  }
  bool isAuthenticated() {
    return _token != null;
  }

  Future<Map<String, dynamic>> getData(String path) async {
    final headers = {
      'Authorization': getToken(),
    };
    try {
      var response = await http.get(Uri.http(_endpoint, path), headers: headers);
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
      'Authorization': getToken(),
    };
    try {
      var response = await http.post(Uri.http(_endpoint, path),
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
      'Authorization': getToken(),
    };
    try {
      var response = await http.delete(Uri.http(_endpoint, path), headers: headers);
      if (response.statusCode != 200) {
        return Future.error(
            'Cannot DELETE /$path -> ${response.statusCode} (${response.reasonPhrase})');
      }
    } on SocketException {
      return Future.error('Connection refused');
    }
  }
}
