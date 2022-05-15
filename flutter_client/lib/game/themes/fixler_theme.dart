import 'package:flutter/material.dart';
import '../common.dart';
import '../theme.dart';

class FixlerTheme extends GameTheme {
  static const _dir = 'assets/images/fixler';

  @override
  String title = 'Fixler';

  @override
  Widget liberalBoard = Image.asset('$_dir/board-liberal.jpg');

  @override
  Widget fascistBoard(int numberOfPlayers) {
    return Image.asset('$_dir/board-fascist-78.jpg');
  }

  @override
  Widget president = Image.asset('$_dir/kapitan.jpg');

  @override
  Widget chancellor = Image.asset('$_dir/spravce.jpg');

  @override
  Widget lastPresident = Image.asset('$_dir/minuly-kapitan.jpg');

  @override
  Widget lastChancellor = Image.asset('$_dir/minuly-spravce.jpg');


  @override
  Widget policy(Side s) {
    switch (s) {
      case Side.liberal:
        return Image.asset('$_dir/policy-liberal.jpg');
      case Side.fascist:
        return Image.asset('$_dir/policy-fascist.jpg');
      case Side.hidden:
        return Image.asset('$_dir/policy-backcover.jpg');
    }
  }

  @override
  Widget role(Role r) {
    switch (r) {
      case Role.liberal:
        return Image.asset('$_dir/role-liberal.jpg');
      case Role.fascist:
        return Image.asset('$_dir/role-fascist.jpg');
      case Role.hitler:
        return Image.asset('$_dir/role-hitler.jpg');
      case Role.unknown:
        return Image.asset('$_dir/role-backcover.jpg');
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
        return Image.asset('$_dir/vote-yes.jpg');
      case Vote.no:
        return Image.asset('$_dir/vote-no.jpg');
      case Vote.unknown:
        return Image.asset('$_dir/vote-backcover.jpg');
      case Vote.none:
        throw UnimplementedError();
    }
  }

  @override
  String presidentName = 'kapitán';

  @override
  String chancellorName = 'správce';

  @override
  String liberalName = 'posádka';

  @override
  String fascistName = 'hacker';
}
