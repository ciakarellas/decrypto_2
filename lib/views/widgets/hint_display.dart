import 'package:flutter/material.dart';
import 'package:decrypto_2/utils/responsive_utils.dart';

class HintDisplay extends StatelessWidget {
  const HintDisplay({
    super.key,
    required this.label,
    this.hint,
    this.onTap,
    this.selectedNumber,
    this.isCorrect,
    this.isSelected = false,
  });

  final String label;
  final String? hint;
  final VoidCallback? onTap;
  final int? selectedNumber;
  final bool? isCorrect;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    // Get responsive size for this HintDisplay
    final hintSize = ResponsiveUtils.getHintDisplaySize(context);
    final numberFontSize = ResponsiveUtils.getAdaptiveFontSize(
      context,
      baseSize: 32.0,
      availableWidth: hintSize.width * 0.8, // Leave some padding
      text: selectedNumber != null
          ? '$selectedNumber'
          : '9', // Test with widest digit
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: hintSize.width,
        height: hintSize.height,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Reserved space for selected number with consistent height
            Text(
              selectedNumber != null ? '$selectedNumber' : '',
              style: TextStyle(
                color: selectedNumber != null
                    ? (isCorrect != null
                          ? (isCorrect! ? Colors.green : Colors.red)
                          : Theme.of(context).colorScheme.primary)
                    : Colors.transparent,
                fontSize: numberFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 8.0),
            ),
            // Display actual hint or placeholder
            if (hint != null && hint!.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getResponsiveSpacing(
                    context,
                    8.0,
                  ),
                  vertical: ResponsiveUtils.getResponsiveSpacing(context, 4.0),
                ),
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
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      12.0,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              // Placeholder for hint content
              Container(
                width: hintSize.width * 0.6,
                height: ResponsiveUtils.getResponsiveSpacing(context, 20.0),
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
