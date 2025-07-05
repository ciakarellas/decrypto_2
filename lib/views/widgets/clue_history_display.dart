import 'package:flutter/material.dart';

class ClueHistoryDisplay extends StatelessWidget {
  // Placeholder for the clue history data
  final Map<int, List<String>> clueHistory;

  const ClueHistoryDisplay({super.key, required this.clueHistory});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Clue History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          // This will be replaced with a more sophisticated implementation
          // to display the clues for each word.
          Text(clueHistory.toString()),
        ],
      ),
    );
  }
}
