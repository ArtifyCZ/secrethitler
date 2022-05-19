import 'package:secrethitler/logger.dart';
import '../game/common.dart';
import 'http_client.dart';


class GameClient {
  static final log = getLogger('GameClient');

  static late final HttpClient _client;
  static String? _playerId;

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
      log.e("Error while voting: ${error.toString()}");
      return null;
    });
  }

  static void discardPolicy(int index) {
    final data = {
      'discardPolicy': index,
    };
    _client.postData('discardPolicy', data).onError((error, stackTrace) {
      log.e("Error while discarding policy: ${error.toString()}");
      return null;
    });
  }

  static void chooseChancellor(int index) {
    final data = {
      'chancellor': index,
    };
    _client.postData('chooseChancellor', data).onError((error, stackTrace) {
      log.e("Cannot choose chancellor: ${error.toString()}");
      return null;
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


  static Future<bool> createGame() async {


    return false;
  }

  // Authentication:
  static Future<bool> anonymousLogin(String username) async {
    if (isAuthenticated()) return false;

    var data = {
      'username': username,
    };

    return _client.postData('auth/anonymous', data).then((value) async {
      if (value == null) return false;

      _client.token = value['token'];
      _playerId = value['id'];
      log.i("Received id '$_playerId' and token '${_client.token}' ");

      return _client.getData('auth').then((value) {
        String id = value['id'];
        if (id == _playerId) {
          log.i("Session check successful");
          return true;
        } else {
          log.e("Session check failed: ids don't match '$_playerId' vs '$id'");
          return false;
        }
      }, onError: (error) {
        log.e("Session check failed: $error");
        return false;
      });
    }, onError: (error) {
      log.e("Login failed: $error");
      return false;
    });
  }

  static void logout() async {
    await _client.deleteData('auth').then((value) {
      log.i('Logged out');
      _client.token = null;
    }, onError: (error) {
      log.e("Log out failed: $error");
    });
  }

  static bool isAuthenticated () {
    return _client.token != null;
  }
}
