import 'package:decrypto_2/models/main_word.dart';

class ClueService {
  // Track which hint indices have been used for each word (by word index)
  final Map<int, Set<int>> _usedHintIndices = {};

  /// Generates three clues based on the provided code and the set of main words.
  ///
  /// Uses the first available (unused) hint for each word in the code.
  /// Each hint can only be used once per game.
  List<String> getCluesForCode(String code, List<MainWord> mainWords) {
    final clues = <String>[];

    for (int i = 0; i < code.length; i++) {
      // The code is 1-based, so subtract 1 for the list index
      final wordIndex = int.parse(code[i]) - 1;

      // Get used hint indices for this word (defaults to empty set if not used yet)
      final usedIndices = _usedHintIndices[wordIndex] ?? <int>{};

      // Get the word and its hints
      final targetWord = mainWords[wordIndex];

      // Find the first unused hint index
      int clueIndex = 0;
      while (clueIndex < targetWord.hints.length &&
          usedIndices.contains(clueIndex)) {
        clueIndex++;
      }

      // If we've used all hints, wrap around (shouldn't happen in normal gameplay)
      if (clueIndex >= targetWord.hints.length) {
        clueIndex = 0;
      }

      final hint = targetWord.hints[clueIndex];
      clues.add(hint);

      // Mark this hint index as used for this word
      if (_usedHintIndices[wordIndex] == null) {
        _usedHintIndices[wordIndex] = <int>{};
      }
      _usedHintIndices[wordIndex]!.add(clueIndex);
    }

    return clues;
  }

  /// Resets the clue usage tracking for a new game.
  /// Call this when starting a new game to ensure fresh clue tracking.
  void resetClueTracking() {
    _usedHintIndices.clear();
  }

  /// Sets that a specific hint index has been used for a word (for initial hints setup)
  void setHintUsed(int wordIndex, int hintIndex) {
    if (_usedHintIndices[wordIndex] == null) {
      _usedHintIndices[wordIndex] = <int>{};
    }
    _usedHintIndices[wordIndex]!.add(hintIndex);
  }

  /// Gets the current used hint indices for debugging/testing purposes.
  Map<int, Set<int>> getUsedHintIndices() {
    return Map<int, Set<int>>.from(_usedHintIndices);
  }
}
