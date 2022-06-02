import 'package:secrethitler/logger.dart';
import '../game/common.dart';
import 'http_client.dart';
import 'package:graphql/client.dart';


class GameClient {
  static final log = getLogger('GameClient');

  static late final HttpClient _client;
  static late final GraphQLClient _graphQLClient;
  static late String _endpoint;
  static String? _playerId;

  static void init(String endpoint) {
    _endpoint = endpoint;

    log.i("Using API at $_endpoint");
    _client = HttpClient(_endpoint);
  }

  static void initGraphQL () {
    final _httpLink = HttpLink('http://$_endpoint/graphql/v1');

    final _authLink = AuthLink(
        getToken: () {
          log.d("GQL is using '${_client.getToken()}' token");
          return _client.getToken();
        }
    );

    Link _link = _authLink.concat(_httpLink);

    /// subscriptions must be split otherwise `HttpLink` will swallow them
    log.d("Creating websocket link");

    final Link _wsLink = WebSocketLink(
        'ws://$_endpoint/graphql/v1/websocket',

      config: SocketClientConfig(
        headers: {
          'Authorization': _client.getToken(),
        }
      ),
    );
    // final Link _wsAuthLink = _httpLink.concat(_wsLink);
    _link = Link.split((request) => request.isSubscription, _wsLink, _link);
    // _link = Link.split((request) => request.isSubscription, _wsAuthLink, _link);

    _graphQLClient = GraphQLClient(
      /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(),
      link: _link,
    );
  }

  static void subscribeGame (String uuid) {
    log.d("Subscribing");
    final subscriptionDocument = gql(
      '''
        subscription {
          game(uuid: "$uuid") {
            hello
          }
        }
      ''',
    );
    var subscription = _graphQLClient.subscribe(
      SubscriptionOptions(
          document: subscriptionDocument,
      ),
    );
    subscription.listen(onTestSubscription);
  }

  static void onTestSubscription (QueryResult result) {
    log.w("Data: ${result.data}");
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


  static Future<String?> createGame() async {
    const String createSlot = r'''
      mutation CreateSlot($nPlayers: Int!) {
        createSlot(players: $nPlayers) {
          uuid
        } 
      }
    ''';

    int nPlayers = 5;

    final QueryOptions options = QueryOptions(
      document: gql(createSlot),
      variables: {
        'nPlayers': nPlayers,
      },
    );

    final QueryResult result = await _graphQLClient.query(options);

    if (result.hasException) {
      log.e(result.exception.toString());
      return null;
    }

    String uuid = result.data?['createSlot']['uuid'] as String;

    log.i("UUID of the new slot: '$uuid'");

    return uuid;
  }

  // Authentication:
  static Future<bool> anonymousLogin(String username) async {
    if (isAuthenticated()) return false;

    var data = {
      'username': username,
    };

    return _client.postData('auth/anonymous', data).then((value) async {
      if (value == null) return false;

      _client.setToken(value['token']);
      _playerId = value['id'];
      log.i("Received id '$_playerId' and token '${_client.getToken()}' ");

      return _client.getData('auth').then((value) {
        String id = value['id'];
        if (id == _playerId) {
          log.i("Session check successful");
          initGraphQL();
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
      _client.clearToken();
    }, onError: (error) {
      log.e("Log out failed: $error");
    });
  }

  static bool isAuthenticated () {
    return _client.isAuthenticated();
  }
}
