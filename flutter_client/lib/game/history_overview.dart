import 'package:flutter/material.dart';
import 'package:secrethitler/game/theme.dart';
import 'common.dart';

class HistoryOverview extends StatelessWidget {
  final List<GameRound> history;

  const HistoryOverview({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: history.length,
      itemBuilder: (context, index) {
        if (history[index].votePassed) {
          return Card(
            color: Colors.grey,
            child: Column(
              children: [
                Text('${GameTheme.currentTheme.presidentName}: ${history[index]
                    .president}'),
                Text('${GameTheme.currentTheme.chancellorName}: ${history[index]
                    .chancellor}'),
                Text('Votes: ${history[index].votes}'),
                Text('Vote passed'),
                Text('President: ${history[index].presidentPolicies}'),
                Text('Chancellor: ${history[index].presidentPolicies}'),
              ],
            ),
          );
        } else {
          return Card(
            color: Colors.grey,
            child: Column(
              children: [
                Text('${GameTheme.currentTheme.presidentName}: ${history[index]
                    .president}'),
                Text('${GameTheme.currentTheme.chancellorName}: ${history[index]
                    .chancellor}'),
                Text('Votes: ${history[index].votes}'),
                Text('Vote failed'),
              ],
            ),
          );
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }
}
