import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decrypto_2/models/game_set.dart';
import 'package:decrypto_2/bloc/game/game_state.dart';
import 'package:decrypto_2/models/main_word.dart';
import 'package:decrypto_2/services/clue_service.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(this._clueService) : super(const GameState());

  final ClueService _clueService;
  late List<MainWord> _secretWords;
  late List<String> _codeDeck;

  void startGame(GameSet gameSet) {
    _secretWords = gameSet.words;
    _codeDeck = List<String>.from(gameSet.codes)..shuffle();

    // Reset clue tracking for the new game
    _clueService.resetClueTracking();

    emit(
      const GameState().copyWith(
        status: GameStatus.playing,
        secretWords: _secretWords,
        clueHistory: const {},
        roundCount: 0,
        successfulGuesses: 0,
        playerScore: 0,
        pairs: const [],
        selectedSecretWord: null,
        showingResults: false,
        lastCorrectCode: null,
      ),
    );

    // Show first hint for all 4 words so user has context
    _showInitialHints();

    // Then automatically trigger the first round
    _triggerAITurn();
  }

  /// Shows the first hint for all 4 words to give user initial context
  void _showInitialHints() {
    final initialClueHistory = <int, List<String>>{};

    // Add first hint for each word (0-based indexing)
    for (int i = 0; i < _secretWords.length; i++) {
      final firstHint = _secretWords[i].hints[0].hintText;
      initialClueHistory[i] = [firstHint];

      // Mark hint index 0 as used for this word
      _clueService.setHintUsed(i, 0);
    }

    emit(state.copyWith(clueHistory: initialClueHistory));
  }

  void submitGuess(String guess) {
    if (state.status != GameStatus.playing) return;

    final newRoundCount = state.roundCount + 1;

    // Always generate a new code for each round
    if (_codeDeck.isEmpty) {
      emit(state.copyWith(status: GameStatus.finished));
      return;
    }
    final codeToCheck = _codeDeck.removeAt(0);

    final isCorrect = guess == codeToCheck;

    // Don't add clues to history yet - wait for user to press START

    if (isCorrect) {
      // Correct guess: increase score and successful guesses
      final newSuccessfulGuesses = state.successfulGuesses + 1;

      // Check win condition: 2 successful guesses
      if (newSuccessfulGuesses >= 2) {
        emit(
          state.copyWith(
            playerScore: state.playerScore + 1,
            successfulGuesses: newSuccessfulGuesses,
            roundCount: newRoundCount,
            status: GameStatus.finished,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          playerScore: state.playerScore + 1,
          successfulGuesses: newSuccessfulGuesses,
          roundCount: newRoundCount,
          showingResults: true,
          lastCorrectCode: codeToCheck,
        ),
      );
    } else {
      // Incorrect guess: increment round count and show results
      emit(
        state.copyWith(
          roundCount: newRoundCount,
          showingResults: true,
          lastCorrectCode: codeToCheck,
        ),
      );

      // Check lose condition: 8 rounds completed without 2 wins
      final currentSuccessfulGuesses = state.successfulGuesses;
      if (newRoundCount >= 8 && currentSuccessfulGuesses < 2) {
        emit(state.copyWith(status: GameStatus.finished));
        return;
      }
    }
  }

  /// Starts the next round after user presses START button
  void startNextRound() {
    if (!state.showingResults) return;

    // First, add the decode clues from previous round to clue history
    // This shows user which words the code referred to
    if (state.currentCode != null && state.currentClues.isNotEmpty) {
      final code = state.currentCode!;
      final clues = state.currentClues;

      // Update clue history by adding decode clues
      final newClueHistory = Map<int, List<String>>.from(state.clueHistory);
      for (int i = 0; i < code.length; i++) {
        final wordIndex = int.parse(code[i]) - 1;
        final clue = clues[i];
        // Get existing clues for this word and add the new one
        final updatedCluesForWord = List<String>.from(
          newClueHistory[wordIndex] ?? [],
        )..add(clue);
        newClueHistory[wordIndex] = updatedCluesForWord;
      }

      // Update state with new clue history and clear results in one go
      emit(
        state.copyWith(
          clueHistory: newClueHistory,
          showingResults: false,
          lastCorrectCode: null,
          pairs: const [],
          selectedSecretWord: null,
        ),
      );
    } else {
      // Just clear results if no clues to add
      emit(
        state.copyWith(
          showingResults: false,
          lastCorrectCode: null,
          pairs: const [],
          selectedSecretWord: null,
        ),
      );
    }

    // Then generate clues for the next round
    _triggerAITurn();
  }

  void _showCluesForCode(String code) {
    final newClues = _clueService.getCluesForCode(code, _secretWords);

    // Only update currentCode and currentClues for HintDisplay
    // Do NOT update clueHistory yet - that would reveal the code to user
    emit(state.copyWith(currentCode: code, currentClues: newClues));
  }

  void _triggerAITurn() {
    if (_codeDeck.isEmpty) {
      // No more codes, game is over
      emit(state.copyWith(status: GameStatus.finished));
      return;
    }

    // Prepare for the new round
    final newCode = _codeDeck.removeAt(0);
    _showCluesForCode(newCode);
  }

  /// Handle SecretWordsDisplay tap - new simplified logic
  void selectWord(int wordNumber) {
    if (state.status != GameStatus.playing || state.showingResults) return;

    // Check if this word is already paired
    final existingPairIndex = state.pairs.indexWhere(
      (pair) => pair.secretWord == wordNumber,
    );

    // If word is already paired, unpair it (user wants to change their mind)
    if (existingPairIndex != -1) {
      final newPairs = List<WordHintPair>.from(state.pairs)
        ..removeAt(existingPairIndex);
      emit(state.copyWith(pairs: newPairs, selectedSecretWord: null));
      return;
    }

    // If this word is currently selected, deselect it
    if (state.selectedSecretWord == wordNumber) {
      emit(state.copyWith(selectedSecretWord: null));
      return;
    }

    // Otherwise, select this word
    emit(state.copyWith(selectedSecretWord: wordNumber));
  }

  /// Handle HintDisplay tap - pair with selected secret word
  void selectPosition(int position) {
    if (state.status != GameStatus.playing ||
        state.showingResults ||
        position < 0 ||
        position > 2) {
      return;
    }

    // Do nothing if no secret word is selected
    if (state.selectedSecretWord == null) return;

    // Check if this position is already used
    final existingPairIndex = state.pairs.indexWhere(
      (pair) => pair.hintPosition == position,
    );

    // If position is already used, do nothing (shouldn't happen in UI)
    if (existingPairIndex != -1) return;

    // Create the new pair
    final newPair = WordHintPair(
      secretWord: state.selectedSecretWord!,
      hintPosition: position,
    );

    final newPairs = List<WordHintPair>.from(state.pairs)..add(newPair);

    emit(state.copyWith(pairs: newPairs, selectedSecretWord: null));

    // Check if all 3 positions are filled
    if (newPairs.length == 3) {
      // Sort pairs by hint position to get correct order
      final sortedPairs = List<WordHintPair>.from(newPairs)
        ..sort((a, b) => a.hintPosition.compareTo(b.hintPosition));

      final guess = sortedPairs
          .map((pair) => pair.secretWord.toString())
          .join('');
      submitGuess(guess);
    }
  }

  /// Clears the selected numbers (for reset functionality)
  void clearSelection() {
    emit(state.copyWith(pairs: const [], selectedSecretWord: null));
  }
}
