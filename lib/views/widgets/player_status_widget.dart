import 'package:flutter/material.dart';

class PlayerStatusWidget extends StatelessWidget {
  final int score;

  const PlayerStatusWidget({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Score', style: TextStyle(fontSize: 18)),
        Text(
          score.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
