import 'dart:developer';
import '../game/common.dart';
import 'http_client.dart';

class GameClient {
  static late final HttpClient _client;
  static String _token = "";
  static String _playerId = "";
  static bool authenticated = false;

  static void init(String endpoint) {
    _client = HttpClient(endpoint);
  }

  static Future<Map<String, dynamic>> getBoard() async {
    return _client.getData('board');
  }

  static void vote(Vote vote) {
    final data = {
      'vote': vote.toString(),
    };
    _client.postData('vote', data).onError((error, stackTrace) {
      log("Error while voting: ${error.toString()}", name: "GameClient");
    });
  }

  static void discardPolicy(int index) {
    final data = {
      'discardPolicy': index,
    };
    _client.postData('discardPolicy', data).onError((error, stackTrace) {
      log("Error while discarding policy: ${error.toString()}", name: "GameClient");
    });
  }

  static void chooseChancellor(int index) {
    final data = {
      'chancellor': index,
    };
    _client.postData('chooseChancellor', data).onError((error, stackTrace) {
      log("Cannot choose chancellor: ${error.toString()}", name: "GameClient");
    });
  }

  static void specialAction(int index) {
    final data = {
      'specialAction': index,
    };
    _client.postData('specialAction', data);
  }

  static void sendChatMsg(String msg) {
    final data = {
      'msg': msg,
    };
    _client.postData('chat', data);
  }

  // Authentication:
  static Future<bool> anonymousLogin(String username) async {
    if (authenticated) return false;

    var data = {
      'username': username,
    };

    return _client.postData('auth/anonymous', data).then((value) async {
      _token = value!['token'];
      _playerId = value['id'];
      authenticated = true;
      log("Received id '$_playerId' and token '$_token' ", name: "GameClient");

      data = {
        'token': _token,
      };

      return _client.postData('auth/check_session', data).then((value) {
        String id = value!['id'];
        if (id == _playerId) {
          log("Session check successful", name: "GameClient");
          return true;
        } else {
          log("Session check failed:", error: "ids don't match '$_playerId' vs '$id'", name: "GameClient");
          return false;
        }
      }, onError: (error) {
        log("Session check failed:", error: error, name: "GameClient");
        return false;
      });
    }, onError: (error) {
      log("Login failed: ", error: error, name: "GameClient");
      return false;
    });
  }

  static void logout() async {
    final data = {
      'token': _token,
    };

    await _client.deleteData('auth/anonymous', data).then((value) {
      log('Logged out', name: "GameClient");
      _token = "";
      _playerId = "";
      authenticated = false;
    }, onError: (error) {
      log("Log out failed:", error: error, name: "GameClient");
    });
  }
}
