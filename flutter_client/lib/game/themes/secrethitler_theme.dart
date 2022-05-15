import 'package:flutter/material.dart';
import '../common.dart';
import '../theme.dart';

class SecretHitlerTheme extends GameTheme {
  static const _dir = 'assets/images/secret-hitler';

  @override
  String title = 'Secret Hitler';

  @override
  Widget liberalBoard = Image.asset('TODO');

  @override
  Widget fascistBoard(int numberOfPlayers) {
    return Image.asset('TODO');
  }

  @override
  Widget president = Image.asset('$_dir/label.president.svg');

  @override
  Widget chancellor = Image.asset('$_dir/label.chancellor.svg');

  @override
  Widget lastPresident = Image.asset('$_dir/minuly-kapitan.jpg');

  @override
  Widget lastChancellor = Image.asset('$_dir/minuly-spravce.jpg');


  @override
  Widget policy(Side s) {
    switch (s) {
      case Side.liberal:
        return Image.asset('$_dir/policy.cards.high.contrast(liberal).svg');
      case Side.fascist:
        return Image.asset('$_dir/policy.cards.high.contrast(fascist).svg');
      case Side.hidden:
        return Image.asset('$_dir/policy.cards.backcover.mirrored.blemish.svg');
    }
  }

  @override
  Widget role(Role r) {
    switch (r) {
      case Role.liberal:
        return Image.asset('$_dir/role.cards(liberal).svg');
      case Role.fascist:
        return Image.asset('$_dir/role.cards(fascist).svg');
      case Role.hitler:
        return Image.asset('$_dir/role.cards(hitler).svg');
      case Role.unknown:
        return Image.asset('$_dir/role.cards.backcover.svg');
    }
  }

  @override
  Widget side(Side s) {
    throw UnimplementedError();
  }

  @override
  Widget vote(Vote v) {
    switch (v) {
      case Vote.yes:
        return Image.asset('$_dir/ballot.cards(ja).svg');
      case Vote.no:
        return Image.asset('$_dir/ballot.cards(nein).svg');
      case Vote.unknown:
        return Image.asset('$_dir/ballot.card.backcover.svg');
      case Vote.none:
        throw UnimplementedError();
    }
  }

  @override
  String presidentName = 'president';

  @override
  String chancellorName = 'chancellor';

  @override
  String liberalName = 'liberal';

  @override
  String fascistName = 'fascist';
}

