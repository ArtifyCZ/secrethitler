
import 'common.dart';

abstract class GameTheme {
  // Texts:
  abstract String presidentName;
  abstract String chancellorName;
  abstract String liberalName;
  abstract String fascistName;

  // Images:
  abstract String liberalBoard;
  abstract String fascistBoard;
  abstract String president;
  abstract String chancellor;
  abstract String lastPresident;
  abstract String lastChancellor;
  String vote(Vote v);
  String role(Role r);
  String side(Side s);
  String policy(Side s);

  static FixlerTheme fixler = FixlerTheme();
  static GameTheme currentTheme = fixler;
}


class FixlerTheme extends GameTheme {
  static const directory = 'assets/images/fixler';

  @override
  String fascistBoard = 'TODO';

  @override
  String liberalBoard = 'TODO';

  @override
  String president = '$directory/kapitan.jpg';

  @override
  String chancellor = '$directory/spravce.jpg';

  @override
  String lastPresident = '$directory/minuly-kapitan.jpg';

  @override
  String lastChancellor = '$directory/minuly-spravce.jpg';


  @override
  String policy(Side s) {
    switch (s) {
      case Side.liberal:
        return '$directory/policy-liberal.jpg';
      case Side.fascist:
        return '$directory/policy-fascist.jpg';
    }
  }

  @override
  String role(Role r) {
    switch (r) {
      case Role.liberal:
        return '$directory/role-liberal.jpg';
      case Role.fascist:
        return '$directory/role-fascist.jpg';
      case Role.hitler:
        return '$directory/role-hitler.jpg';
      case Role.unknown:
        return '$directory/role-backcover.jpg';
    }
  }

  @override
  String side(Side s) {
    throw UnimplementedError();
  }

  @override
  String vote(Vote v) {
    switch (v) {
      case Vote.yes:
        return '$directory/vote-yes.jpg';
      case Vote.no:
        return '$directory/vote-no.jpg';
      case Vote.unknown:
        return '$directory/vote-backcover.jpg';
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