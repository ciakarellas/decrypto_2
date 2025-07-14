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
      final firstHint = _secretWords[i].hints[0];
      initialClueHistory[i] = [firstHint];

      // Update clue service usage count so it knows hint[0] was used
      _clueService.getUsageCount()[i] = 1;
    }

    emit(state.copyWith(clueHistory: initialClueHistory));
  }

  void submitGuess(String guess) {
    if (state.status != GameStatus.playing) return;

    final newRoundCount = state.roundCount + 1;

    // If this is the first guess or we need a new code, generate one first
    String codeToCheck;
    if (state.currentCode == null) {
      // First guess - generate the code now
      if (_codeDeck.isEmpty) {
        emit(state.copyWith(status: GameStatus.finished));
        return;
      }
      codeToCheck = _codeDeck.removeAt(0);
    } else {
      // Use existing code
      codeToCheck = state.currentCode!;
    }

    final isCorrect = guess == codeToCheck;

    // After user attempts guess, add decode clues to clue history
    _addCurrentCluesToHistory();

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
        ),
      );

      // Generate new code for next round
      _triggerAITurn();
    } else {
      // Incorrect guess: just increment round count
      emit(state.copyWith(roundCount: newRoundCount));

      // Check lose condition: 8 rounds completed without 2 wins
      final currentSuccessfulGuesses = state.successfulGuesses;
      if (newRoundCount >= 8 && currentSuccessfulGuesses < 2) {
        emit(state.copyWith(status: GameStatus.finished));
        return;
      }

      // Keep showing the same code for next guess attempt
    }
  }

  /// Adds the current decode clues to clue history so they appear in SecretWordsDisplay
  void _addCurrentCluesToHistory() {
    if (state.currentCode == null || state.currentClues.isEmpty) return;

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

    emit(state.copyWith(clueHistory: newClueHistory));
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
}
