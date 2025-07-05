import 'package:flutter/material.dart';

class EndGameScreen extends StatelessWidget {
  final int finalScore;
  const EndGameScreen({super.key, required this.finalScore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
        automaticallyImplyLeading: false, // Prevents the back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Final Score: $finalScore', // Placeholder score
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
