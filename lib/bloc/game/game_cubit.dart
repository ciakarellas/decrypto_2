import 'package:bloc/bloc.dart';
import 'package:decrypto_2/models/game_set.dart';
import 'package:decrypto_2/bloc/game/game_state.dart';
import 'package:decrypto_2/models/main_word.dart';
import 'package:decrypto_2/services/ai_service.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(this._aiService) : super(const GameState());

  final AIService _aiService;
  late List<MainWord> _secretWords;
  late List<String> _codeDeck;

  void startGame(GameSet gameSet) {
    _secretWords = gameSet.words;
    _codeDeck = List<String>.from(gameSet.codes)..shuffle();

    emit(
      const GameState().copyWith(
        status: GameStatus.playing,
        secretWords: _secretWords,
        clueHistory: const {},
        playerLives: 2,
        playerScore: 0,
      ),
    );

    _triggerAITurn();
  }

  void submitGuess(String guess) {
    if (state.status != GameStatus.playing) return;

    final isCorrect = guess == state.currentCode;

    if (isCorrect) {
      // Correct guess: increase score
      emit(state.copyWith(playerScore: state.playerScore + 1));
    } else {
      // Incorrect guess: lose a life
      final newLives = state.playerLives - 1;
      if (newLives <= 0) {
        // Game over
        emit(state.copyWith(playerLives: 0, status: GameStatus.finished));
        return;
      }
      emit(state.copyWith(playerLives: newLives));
    }

    // If the game is not over, trigger the next round
    _triggerAITurn();
  }

  void _triggerAITurn() {
    if (_codeDeck.isEmpty) {
      // No more codes, game is over
      emit(state.copyWith(status: GameStatus.finished));
      return;
    }

    // Prepare for the new round
    final newCode = _codeDeck.removeAt(0);
    final newClues = _aiService.getCluesForCode(newCode, _secretWords);

    // Update clue history
    final newClueHistory = Map<int, List<String>>.from(state.clueHistory);
    for (int i = 0; i < newCode.length; i++) {
      final wordIndex = int.parse(newCode[i]) - 1;
      final clue = newClues[i];
      final updatedCluesForWord = List<String>.from(
        newClueHistory[wordIndex] ?? [],
      )..add(clue);
      newClueHistory[wordIndex] = updatedCluesForWord;
    }

    // Emit the new state for the player to see
    emit(
      state.copyWith(
        currentCode: newCode,
        currentClues: newClues,
        clueHistory: newClueHistory,
      ),
    );
  }
}
