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
      // Incorrect guess: just increment round count and show clues for current code
      emit(state.copyWith(roundCount: newRoundCount));

      // Check lose condition: 8 rounds completed without 2 wins
      final currentSuccessfulGuesses = state.successfulGuesses;
      if (newRoundCount >= 8 && currentSuccessfulGuesses < 2) {
        emit(state.copyWith(status: GameStatus.finished));
        return;
      }

      // Show clues for the current code
      _showCluesForCode(codeToCheck);
    }
  }

  void _showCluesForCode(String code) {
    final newClues = _clueService.getCluesForCode(code, _secretWords);

    // Update clue history
    final newClueHistory = Map<int, List<String>>.from(state.clueHistory);
    for (int i = 0; i < code.length; i++) {
      final wordIndex = int.parse(code[i]) - 1;
      final clue = newClues[i];
      final updatedCluesForWord = List<String>.from(
        newClueHistory[wordIndex] ?? [],
      )..add(clue);
      newClueHistory[wordIndex] = updatedCluesForWord;
    }

    // Emit the new state for the player to see
    emit(
      state.copyWith(
        currentCode: code,
        currentClues: newClues,
        clueHistory: newClueHistory,
      ),
    );
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
