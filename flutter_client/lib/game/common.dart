enum Side {
  liberal,
  fascist,
}

enum Role {
  liberal,
  fascist,
  hitler,

  unknown,
}

enum Vote {
  yes,
  no,

  unknown,
  none, // player hasn't voted yet
}

enum GameState {
  waiting,
  choosingChancellor,
  voting,
  discardingPolicy,
  specialAction,
  ended,
}

class GameRound {
  int president;
  int chancellor;
  List<Vote> votes;
  bool votePassed;
  List<Side>? presidentPolicies; // len 3
  List<Side>? chancellorPolicies; // len 2
  Side? policy;
  int? specialAction;

  GameRound({
    required this.president,
    required this.chancellor,
    required this.votes,
    required this.votePassed,
    this.presidentPolicies,
    this.chancellorPolicies,
    this.policy,
    this.specialAction,
  });
}
