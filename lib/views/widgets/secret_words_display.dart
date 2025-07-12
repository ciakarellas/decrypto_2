import 'package:flutter/material.dart';

class SecretWordsDisplay extends StatelessWidget {
  const SecretWordsDisplay({
    super.key,
    required this.secretWords,
    this.showWords = false,
    this.clueHistory = const {},
  });

  final List<String> secretWords;
  final bool showWords;
  final Map<int, List<String>>
  clueHistory; // Map of word position (1-4) to list of clues

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row: Words 1 and 2
        Row(
          children: [
            Expanded(child: _buildWordSection(context, 0)), // Word 1
            const SizedBox(width: 16),
            Expanded(child: _buildWordSection(context, 1)), // Word 2
          ],
        ),
        const SizedBox(height: 20),
        // Second row: Words 3 and 4
        Row(
          children: [
            Expanded(child: _buildWordSection(context, 2)), // Word 3
            const SizedBox(width: 16),
            Expanded(child: _buildWordSection(context, 3)), // Word 4
          ],
        ),
      ],
    );
  }

  Widget _buildWordSection(BuildContext context, int index) {
    final wordNumber = index + 1;
    final clues = clueHistory[wordNumber] ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Word number
        Text(
          '$wordNumber',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 20),
        // Clue history sectionR
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clues:',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              if (clues.isEmpty)
                Text(
                  'No clues yet',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                )
              else
                ...clues.map(
                  (clue) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      '• $clue',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
