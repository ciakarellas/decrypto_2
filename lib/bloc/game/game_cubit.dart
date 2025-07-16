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
        selectedNumbers: const [null, null, null],
        selectedWordNumber: null,
        selectedPosition: null,
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
      final firstHint = _secretWords[i].hints[0];
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
          selectedNumbers: const [null, null, null],
          selectedWordNumber: null,
          selectedPosition: null,
        ),
      );
    } else {
      // Just clear results if no clues to add
      emit(
        state.copyWith(
          showingResults: false,
          lastCorrectCode: null,
          selectedNumbers: const [null, null, null],
          selectedWordNumber: null,
          selectedPosition: null,
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

  /// Handle SecretWordsDisplay tap - bidirectional selection
  void selectWord(int wordNumber) {
    if (state.status != GameStatus.playing || state.showingResults) return;

    final currentNumbers = List<int?>.from(state.selectedNumbers);

    // Check if this word is already placed somewhere
    int? currentPositionOfWord;
    for (int i = 0; i < currentNumbers.length; i++) {
      if (currentNumbers[i] == wordNumber) {
        currentPositionOfWord = i;
        break;
      }
    }

    // If word is already placed, remove it (deselect)
    if (currentPositionOfWord != null) {
      currentNumbers[currentPositionOfWord] = null;
      emit(
        state.copyWith(
          selectedNumbers: currentNumbers,
          selectedWordNumber: null,
          selectedPosition: null,
        ),
      );
      return;
    }

    // If a position is already selected, place word there immediately
    if (state.selectedPosition != null) {
      _placeWordAtPosition(wordNumber, state.selectedPosition!);
      return;
    }

    // Otherwise, just select this word (toggle selection)
    final newSelectedWordNumber = state.selectedWordNumber == wordNumber
        ? null
        : wordNumber;

    emit(
      state.copyWith(
        selectedWordNumber: newSelectedWordNumber,
        selectedPosition: null, // Clear position selection when selecting word
      ),
    );
  }

  /// Handle HintDisplay tap - bidirectional selection
  void selectPosition(int position) {
    if (state.status != GameStatus.playing ||
        state.showingResults ||
        position < 0 ||
        position > 2) {
      return;
    }

    final currentNumbers = List<int?>.from(state.selectedNumbers);

    // If position already has a number, remove it (deselect)
    if (currentNumbers[position] != null) {
      currentNumbers[position] = null;
      emit(
        state.copyWith(
          selectedNumbers: currentNumbers,
          selectedWordNumber: null,
          selectedPosition: null,
        ),
      );
      return;
    }

    // If a word is already selected, place it here immediately
    if (state.selectedWordNumber != null) {
      _placeWordAtPosition(state.selectedWordNumber!, position);
      return;
    }

    // Otherwise, just select this position (toggle selection)
    final newSelectedPosition = state.selectedPosition == position
        ? null
        : position;

    emit(
      state.copyWith(
        selectedPosition: newSelectedPosition,
        selectedWordNumber:
            null, // Clear word selection when selecting position
      ),
    );
  }

  /// Internal helper to place word at position and handle auto-submit
  void _placeWordAtPosition(int wordNumber, int position) {
    final currentNumbers = List<int?>.from(state.selectedNumbers);

    // Remove this word number from any other position first
    for (int i = 0; i < currentNumbers.length; i++) {
      if (currentNumbers[i] == wordNumber) {
        currentNumbers[i] = null;
      }
    }

    // Place the word number at the specified position
    currentNumbers[position] = wordNumber;

    emit(
      state.copyWith(
        selectedNumbers: currentNumbers,
        selectedWordNumber: null, // Clear selections after placing
        selectedPosition: null,
      ),
    );

    // Check if all 3 positions are filled
    if (currentNumbers.every((number) => number != null)) {
      final guess = currentNumbers.map((n) => n.toString()).join('');
      submitGuess(guess);
    }
  }

  /// Clears the selected numbers (for reset functionality)
  void clearSelection() {
    emit(
      state.copyWith(
        selectedNumbers: const [null, null, null],
        selectedWordNumber: null,
        selectedPosition: null,
      ),
    );
  }
}
