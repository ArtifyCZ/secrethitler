import 'package:flutter/material.dart';

import 'common.dart';

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
      color: Colors.black.withAlpha(80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(policies.length, (index) => policyCard(context, index)),
      ),
    );
  }

  Widget policyCard (BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
      child: ElevatedButton(
        onPressed: () {
          onSelectPolicy(index);
        },
        child: policies[index] == Side.liberal ? Image.asset('assets/images/fixler/policy-liberal.jpg') : Image.asset('assets/images/fixler/policy-fascist.jpg'),
      ),
    );
  }
}
