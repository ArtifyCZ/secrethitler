import 'package:flutter/material.dart';

import 'common.dart';
import 'theme.dart';

typedef PolicyCallback = Function(int index);

class PolicyOverlay extends StatelessWidget {
  final PolicyCallback onSelectPolicy;
  final List<Side> policies;

  const PolicyOverlay({
    Key? key,
    required this.onSelectPolicy,
    required this.policies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(90),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(policies.length, (index) => policyCard(context, index)),
      ),
    );
  }

  Widget policyCard (BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
      child: TextButton(
        onPressed: () {
          onSelectPolicy(index);
        },
        child: GameTheme.currentTheme.policy(policies[index]),
      ),
    );
  }
}
