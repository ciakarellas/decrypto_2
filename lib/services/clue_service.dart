import 'package:decrypto_2/models/main_word.dart';

class ClueService {
  // Track how many clues have been used for each word (by word index)
  final Map<int, int> _clueUsageCount = {};

  /// Generates three clues based on the provided code and the set of main words.
  ///
  /// Uses clues in order (1st, 2nd, 3rd, etc.) based on how many times each word
  /// has been used. For example:
  /// - Code "143": clue[0] from word 1, clue[0] from word 4, clue[0] from word 3
  /// - Code "241": clue[0] from word 2, clue[1] from word 4, clue[1] from word 1
  List<String> getCluesForCode(String code, List<MainWord> mainWords) {
    final clues = <String>[];

    for (int i = 0; i < code.length; i++) {
      // The code is 1-based, so subtract 1 for the list index
      final wordIndex = int.parse(code[i]) - 1;

      // Get current usage count for this word (defaults to 0 if not used yet)
      final currentUsageCount = _clueUsageCount[wordIndex] ?? 0;

      // Get the word and its hints
      final targetWord = mainWords[wordIndex];

      // Use the clue at the current usage index
      // Wrap around if we've used all clues (though this shouldn't happen in normal gameplay)
      final clueIndex = currentUsageCount % targetWord.hints.length;
      final hint = targetWord.hints[clueIndex];

      clues.add(hint);

      // Increment usage count for this word
      _clueUsageCount[wordIndex] = currentUsageCount + 1;
    }

    return clues;
  }

  /// Resets the clue usage tracking for a new game.
  /// Call this when starting a new game to ensure fresh clue tracking.
  void resetClueTracking() {
    _clueUsageCount.clear();
  }

  /// Gets the current usage count for debugging/testing purposes.
  Map<int, int> getUsageCount() {
    return Map<int, int>.from(_clueUsageCount);
  }
}
