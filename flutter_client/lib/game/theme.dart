
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'common.dart';

abstract class GameTheme {
  // Texts:
  abstract String title;
  abstract String presidentName;
  abstract String chancellorName;
  abstract String liberalName;
  abstract String fascistName;

  // Images:
  abstract Widget liberalBoard;
  abstract Widget fascistBoard;
  abstract Widget president;
  abstract Widget chancellor;
  abstract Widget lastPresident;
  abstract Widget lastChancellor;
  Widget vote(Vote v);
  Widget role(Role r);
  Widget side(Side s);
  Widget policy(Side s);

  static final FixlerTheme _fixler = FixlerTheme();
  // static final SecretHitlerTheme _secretHitler = SecretHitlerTheme();
  static final SecretHitlerSvgTheme _secretHitlerSvg = SecretHitlerSvgTheme();

  static final GameTheme currentTheme = _fixler;
}

class SecretHitlerTheme extends GameTheme {
  static const _directory = 'assets/images/secret-hitler';

  @override
  String title = 'Secret Hitler';

  @override
  Widget fascistBoard = SvgPicture.asset('TODO');

  @override
  Widget liberalBoard = SvgPicture.asset('TODO');

  @override
  Widget president = SvgPicture.asset('$_directory/label.president.svg');

  @override
  Widget chancellor = SvgPicture.asset('$_directory/label.chancellor.svg');

  @override
  Widget lastPresident = SvgPicture.asset('$_directory/minuly-kapitan.jpg');

  @override
  Widget lastChancellor = SvgPicture.asset('$_directory/minuly-spravce.jpg');


  @override
  Widget policy(Side s) {
    switch (s) {
      case Side.liberal:
        return SvgPicture.asset('$_directory/policy.cards.high.contrast(liberal).svg');
      case Side.fascist:
        return SvgPicture.asset('$_directory/policy.cards.high.contrast(fascist).svg');
      case Side.hidden:
        return SvgPicture.asset('$_directory/policy.cards.backcover.mirrored.blemish.svg');
    }
  }

  @override
  Widget role(Role r) {
    switch (r) {
      case Role.liberal:
        return SvgPicture.asset('$_directory/role.cards(liberal).svg');
      case Role.fascist:
        return SvgPicture.asset('$_directory/role.cards(fascist).svg');
      case Role.hitler:
        return SvgPicture.asset('$_directory/role.cards(hitler).svg');
      case Role.unknown:
        return SvgPicture.asset('$_directory/role.cards.backcover.svg');
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
        return SvgPicture.asset('$_directory/ballot.cards(ja).svg');
      case Vote.no:
        return SvgPicture.asset('$_directory/ballot.cards(nein).svg');
      case Vote.unknown:
        return SvgPicture.asset('$_directory/ballot.card.backcover.svg');
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

class SecretHitlerSvgTheme extends SecretHitlerTheme {
  static const _directory = 'assets/images/secret-hitler-svg';

  @override
  Widget fascistBoard = SvgPicture.asset('TODO');

  @override
  Widget liberalBoard = SvgPicture.asset('TODO');

  @override
  Widget president = SvgPicture.asset('$_directory/label.president.svg');

  @override
  Widget chancellor = SvgPicture.asset('$_directory/label.chancellor.svg');

  @override
  Widget lastPresident = SvgPicture.asset('$_directory/minuly-kapitan.jpg');

  @override
  Widget lastChancellor = SvgPicture.asset('$_directory/minuly-spravce.jpg');


  @override
  Widget policy(Side s) {
    switch (s) {
      case Side.liberal:
        return SvgPicture.asset('$_directory/policy.cards.high.contrast(liberal).svg');
      case Side.fascist:
        return SvgPicture.asset('$_directory/policy.cards.high.contrast(fascist).svg');
      case Side.hidden:
        return SvgPicture.asset('$_directory/policy.cards.backcover.mirrored.blemish.svg');
    }
  }

  @override
  Widget role(Role r) {
    switch (r) {
      case Role.liberal:
        return SvgPicture.asset('$_directory/role.cards(liberal).svg');
      case Role.fascist:
        return SvgPicture.asset('$_directory/role.cards(fascist).svg');
      case Role.hitler:
        return SvgPicture.asset('$_directory/role.cards(hitler).svg');
      case Role.unknown:
        return SvgPicture.asset('$_directory/role.cards.backcover.svg');
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
        return SvgPicture.asset('$_directory/ballot.cards(ja).svg');
      case Vote.no:
        return SvgPicture.asset('$_directory/ballot.cards(nein).svg');
      case Vote.unknown:
        return SvgPicture.asset('$_directory/ballot.card.backcover.svg');
      case Vote.none:
        throw UnimplementedError();
    }
  }
}



class FixlerTheme extends GameTheme {
  static const _directory = 'assets/images/fixler';

  @override
  String title = 'Fixler';

  @override
  Widget fascistBoard = Image.asset('TODO');

  @override
  Widget liberalBoard = Image.asset('TODO');

  @override
  Widget president = Image.asset('$_directory/kapitan.jpg');

  @override
  Widget chancellor = Image.asset('$_directory/spravce.jpg');

  @override
  Widget lastPresident = Image.asset('$_directory/minuly-kapitan.jpg');

  @override
  Widget lastChancellor = Image.asset('$_directory/minuly-spravce.jpg');


  @override
  Widget policy(Side s) {
    switch (s) {
      case Side.liberal:
        return Image.asset('$_directory/policy-liberal.jpg');
      case Side.fascist:
        return Image.asset('$_directory/policy-fascist.jpg');
      case Side.hidden:
        return Image.asset('$_directory/policy-backcover.jpg');
    }
  }

  @override
  Widget role(Role r) {
    switch (r) {
      case Role.liberal:
        return Image.asset('$_directory/role-liberal.jpg');
      case Role.fascist:
        return Image.asset('$_directory/role-fascist.jpg');
      case Role.hitler:
        return Image.asset('$_directory/role-hitler.jpg');
      case Role.unknown:
        return Image.asset('$_directory/role-backcover.jpg');
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
        return Image.asset('$_directory/vote-yes.jpg');
      case Vote.no:
        return Image.asset('$_directory/vote-no.jpg');
      case Vote.unknown:
        return Image.asset('$_directory/vote-backcover.jpg');
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

