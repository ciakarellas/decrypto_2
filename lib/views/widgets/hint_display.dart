import 'package:flutter/material.dart';

class HintDisplay extends StatelessWidget {
  const HintDisplay({super.key, required this.label, this.hint, this.onTap});

  final String label;
  final String? hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Reserved space where icon was (keep for future use)
            const SizedBox(height: 32),
            const SizedBox(height: 8),
            // Display actual hint or placeholder
            if (hint != null && hint!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  hint!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              // Placeholder for hint content
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
