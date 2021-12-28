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
