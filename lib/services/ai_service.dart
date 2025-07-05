import 'dart:math';

import 'package:decrypto_2/models/main_word.dart';

class AIService {
  /// Generates three clues based on the provided code and the set of main words.
  ///
  /// For the MVP, this simply picks a random hint from the list of available
  /// hints for the corresponding word.
  List<String> getCluesForCode(String code, List<MainWord> mainWords) {
    final random = Random();
    final clues = <String>[];

    for (int i = 0; i < code.length; i++) {
      // The code is 1-based, so subtract 1 for the list index.
      final wordIndex = int.parse(code[i]) - 1;
      final targetWord = mainWords[wordIndex];

      // Pick a random hint from the word's hint list.
      final hint = targetWord.hints[random.nextInt(targetWord.hints.length)];
      clues.add(hint);
    }

    return clues;
  }
}
