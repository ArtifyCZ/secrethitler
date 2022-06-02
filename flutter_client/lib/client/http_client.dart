import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:secrethitler/logger.dart';

final _log = getLogger('GameClient');

class MyHttpClient {
  final String _host;
  final int _port;
  final HttpClient _http;

  String? _token;

  MyHttpClient(this._host, this._port) : _http = HttpClient();

  String getToken() {
    _log.wtf("getToken -> '$_token'");
    return _token ?? "None";
  }

  void setToken(String token) {
    _log.wtf("setToken('$token')");
    _token = token;
  }

  void clearToken() {
    _log.wtf("clearToken()");
    _token = null;
  }

  bool isAuthenticated() {
    _log.wtf("isAuthenticated -> ${_token != null}");
    return _token != null;
  }

  Future<Map<String, dynamic>> getData(String path) async {
    // final headers = {
    //   // 'Authorization': getToken(),
    //   'Cookie': "Authorization=${getToken()}",
    // };
    try {
      // var response = await http.get(Uri.http(_endpoint, path), headers: headers);
      HttpClientRequest request = await _http.get(_host, _port, path);
      request.cookies.add(Cookie("Authorization", getToken()));
      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        try {
          final body = await response.transform(utf8.decoder).join();
          return jsonDecode(body);
        } catch (e, _) {
          return Future.error('Cannot decode JSON response: ${e.toString()}');
        }
      }
      return Future.error('Cannot GET /$path -> ${response.statusCode}');
    } on SocketException {
      return Future.error('Connection refused');
    }
  }

  Future<Map<String, dynamic>?> postData(String path, Map<String, dynamic> data) async {
    // final headers = {
    //   'Content-Type': 'application/json',
    //   // 'Authorization': getToken(),
    //   'Cookie': "Authorization=${getToken()}",
    // };
    try {
      // var response = await http.post(Uri.http(_endpoint, path), headers: headers, body: json.encode(data));
      HttpClientRequest request = await _http.post(_host, _port, path);
      request.cookies.add(Cookie("Authorization", getToken()));
      request.headers.contentType = ContentType.json;
      request.write(json.encode(data));
      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        try {
          final body = await response.transform(utf8.decoder).join();
          return jsonDecode(body);
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
    // final headers = {
    //   'Content-Type': 'application/json',
    //   // 'Authorization': getToken(),
    //   'Cookie': "Authorization=${getToken()}",
    // };
    try {
      HttpClientRequest request = await _http.delete(_host, _port, path);
      request.cookies.add(Cookie("Authorization", getToken()));
      HttpClientResponse response = await request.close();
      if (response.statusCode != 200) {
        return Future.error('Cannot DELETE /$path -> ${response.statusCode} (${response.reasonPhrase})');
      }
    } on SocketException {
      return Future.error('Connection refused');
    }
  }
}
