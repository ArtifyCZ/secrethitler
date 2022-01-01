
import 'common.dart';

abstract class GameTheme {
  // Texts:
  abstract String president;
  abstract String chancellor;
  abstract String liberal;
  abstract String fascist;

  // Images:
  abstract String liberalBoard;
  abstract String fascistBoard;
  String vote(Vote v);
  String role(Role r);
  String side(Side s);
  String policy(Side s);

  static FixlerTheme fixler = FixlerTheme();
  static GameTheme currentTheme = fixler;
}


class FixlerTheme extends GameTheme {
  final directory = 'assets/images/fixler';


  @override
  String fascistBoard = 'TODO';

  @override
  String liberalBoard = 'TODO';

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
  String president = 'kapitán';

  @override
  String chancellor = 'správce';

  @override
  String liberal = 'posádka';

  @override
  String fascist = 'hacker';

}