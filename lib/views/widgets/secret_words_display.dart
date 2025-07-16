import 'package:flutter/material.dart';

class SecretWordsDisplay extends StatelessWidget {
  const SecretWordsDisplay({
    super.key,
    required this.wordNumber,
    required this.word,
    this.showWord = false,
    this.hints = const [],
    this.onTap,
    this.isSelected = false,
    this.isPaired = false,
  });

  final int wordNumber;
  final String word;
  final bool showWord;
  final List<String> hints;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isPaired;

  @override
  Widget build(BuildContext context) {
    // Calculate responsive height based on screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final componentHeight = (screenHeight * 0.18).clamp(120.0, 160.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: componentHeight,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPaired
              ? Colors.green.withValues(alpha: 0.3)
              : isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPaired
                ? Colors.green
                : isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            width: (isPaired || isSelected) ? 2.0 : 1.0,
          ),
        ),
        child: Stack(
          children: [
            // Background watermark number in center
            Positioned.fill(
              child: Center(
                child: Text(
                  '$wordNumber',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
            // Main content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Show actual word if enabled (for debugging or end game)
                if (showWord) ...[
                  Text(
                    word,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                // Hints section with flexible height
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Simple clues header (no inline number)
                        Text(
                          'Clues:',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        // Scrollable hints area to handle up to 8 hints
                        Expanded(
                          child: hints.isEmpty
                              ? Text(
                                  'No clues yet',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                )
                              : SingleChildScrollView(
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: hints
                                        .map(
                                          (hint) => Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              hint,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
