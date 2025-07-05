import 'package:flutter/material.dart';

class PlayerStatusWidget extends StatelessWidget {
  final int score;
  final int lives;

  const PlayerStatusWidget({super.key, required this.score, required this.lives});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text('Score', style: TextStyle(fontSize: 18)),
            Text(score.toString(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        Column(
          children: [
            const Text('Lives', style: TextStyle(fontSize: 18)),
            Row(
              children: List.generate(lives, (index) {
                return const Icon(Icons.favorite, color: Colors.red);
              }),
            )
          ],
        ),
      ],
    );
  }
}
