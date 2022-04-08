import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../common.dart';
import 'secrethitler_theme.dart';

class SecretHitlerSvgTheme extends SecretHitlerTheme {
  static const _dir = 'assets/images/secret-hitler-svg';

  @override
  Widget liberalBoard = SvgPicture.asset('liberal.board(front).svg');

  @override
  Widget fascistBoard(int numberOfPlayers) {
    if (numberOfPlayers >= 5 && numberOfPlayers <= 6) {
      return SvgPicture.asset('fascist.board(front-56).svg');
    } else if (numberOfPlayers >= 7 && numberOfPlayers <= 8) {
      return SvgPicture.asset('fascist.board(front-78).svg');
    } else if (numberOfPlayers >= 9 && numberOfPlayers <= 10) {
      return SvgPicture.asset('fascist.board(front-910).svg');
    } else {
      return SvgPicture.asset('unsupported number of players');
    }
  }

  @override
  Widget president = SvgPicture.asset('$_dir/label.president.svg');

  @override
  Widget chancellor = SvgPicture.asset('$_dir/label.chancellor.svg');

  @override
  Widget lastPresident = SvgPicture.asset('$_dir/minuly-kapitan.jpg');

  @override
  Widget lastChancellor = SvgPicture.asset('$_dir/minuly-spravce.jpg');


  @override
  Widget policy(Side s) {
    switch (s) {
      case Side.liberal:
        return SvgPicture.asset('$_dir/policy.cards.high.contrast(liberal).svg');
      case Side.fascist:
        return SvgPicture.asset('$_dir/policy.cards.high.contrast(fascist).svg');
      case Side.hidden:
        return SvgPicture.asset('$_dir/policy.cards.backcover.mirrored.blemish.svg');
    }
  }

  @override
  Widget role(Role r) {
    switch (r) {
      case Role.liberal:
        return SvgPicture.asset('$_dir/role.cards(liberal).svg');
      case Role.fascist:
        return SvgPicture.asset('$_dir/role.cards(fascist).svg');
      case Role.hitler:
        return SvgPicture.asset('$_dir/role.cards(hitler).svg');
      case Role.unknown:
        return SvgPicture.asset('$_dir/role.cards.backcover.svg');
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
        return SvgPicture.asset('$_dir/ballot.cards(ja).svg');
      case Vote.no:
        return SvgPicture.asset('$_dir/ballot.cards(nein).svg');
      case Vote.unknown:
        return SvgPicture.asset('$_dir/ballot.card.backcover.svg');
      case Vote.none:
        throw UnimplementedError();
    }
  }
}




