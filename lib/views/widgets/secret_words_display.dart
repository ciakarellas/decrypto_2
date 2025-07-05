import 'package:decrypto_2/views/widgets/word_card.dart';
import 'package:flutter/material.dart';

class SecretWordsDisplay extends StatelessWidget {
  const SecretWordsDisplay({super.key, required this.secretWords});

  final List<String> secretWords;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(secretWords.length, (index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8),
            WordCard(word: secretWords[index]),
          ],
        );
      }),
    );
  }
}
