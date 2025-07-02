import 'package:bloc/bloc.dart';
import 'package:decrypto_2/models/game_state.dart';
import 'package:decrypto_2/models/main_word.dart';
// import 'package:decrypto_2/models/player.dart';
// import 'package:decrypto_2/models/team.dart';
import 'package:decrypto_2/services/word_service.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(this._wordService) : super(GameState.initial());

  final WordService _wordService;

  void startGame() {
    final gameSet = _wordService.getNewGameSet();
    final secretWords = gameSet.mainWords
        .map((MainWord mw) => mw.word)
        .toList();

    // Initialize clue history for 4 words
    final initialClueHistory = {0: [], 1: [], 2: [], 3: []};

    // Create a human player and an AI player
    const humanPlayer = Player(id: 'p1', name: 'Player 1');
    const aiPlayer = Player(id: 'p2', name: 'AI Player', isAI: true);

    // Create two teams
    final humanTeam = Team(
      players: const [humanPlayer],
      secretWords: secretWords,
      clueHistory: Map<int, List<String>>.from(initialClueHistory),
    );
    final aiTeam = Team(
      players: const [aiPlayer],
      secretWords: secretWords, // For MVP, both teams use the same words
      clueHistory: Map<int, List<String>>.from(initialClueHistory),
    );

    final codeDeck = List<String>.from(gameSet.codes)..shuffle();
    final firstCode = codeDeck.removeAt(0);

    emit(
      state.copyWith(
        teams: [humanTeam, aiTeam],
        currentRound: 1,
        status: GameStatus.playing,
        activeTeamIndex: 0, // Human team starts
        turnPhase: TurnPhase.clueGiving,
        codeDeck: codeDeck,
        currentCode: firstCode,
        currentClues: [],
      ),
    );
  }

  void submitClues(List<String> clues) {
    if (state.status != GameStatus.playing ||
        state.turnPhase != TurnPhase.clueGiving) {
      return; // Ignore if not in the correct state
    }

    final activeTeam = state.teams[state.activeTeamIndex];
    final newClueHistory = Map<int, List<String>>.from(activeTeam.clueHistory);

    // Associate clues with words based on the current code
    for (int i = 0; i < state.currentCode.length; i++) {
      final wordIndex = int.parse(state.currentCode[i]) - 1;
      final clue = clues[i];

      // Add the new clue to the history for that word
      final updatedCluesForWord = List<String>.from(newClueHistory[wordIndex]!)
        ..add(clue);
      newClueHistory[wordIndex] = updatedCluesForWord;
    }

    final updatedTeam = activeTeam.copyWith(clueHistory: newClueHistory);
    final updatedTeams = List<Team>.from(state.teams)
      ..[state.activeTeamIndex] = updatedTeam;

    emit(
      state.copyWith(
        teams: updatedTeams,
        currentClues: clues,
        turnPhase: TurnPhase.interceptGuessing,
      ),
    );
  }

  void submitGuess(String guess) {
    if (state.status != GameStatus.playing) return;

    final isCorrect = guess == state.currentCode;
    var updatedTeams = List<Team>.from(state.teams);
    var gameStatus = state.status;

    if (state.turnPhase == TurnPhase.interceptGuessing) {
      final interceptingTeamIndex = (state.activeTeamIndex + 1) % 2;
      if (isCorrect) {
        final interceptingTeam = updatedTeams[interceptingTeamIndex];
        final newTokens = interceptingTeam.interceptionTokens + 1;
        updatedTeams[interceptingTeamIndex] = interceptingTeam.copyWith(
          interceptionTokens: newTokens,
        );
        if (newTokens >= 2) {
          gameStatus = GameStatus.finished;
        }
      }
      // Whether the guess was correct or not, move to the next phase
      emit(
        state.copyWith(
          teams: updatedTeams,
          status: gameStatus,
          turnPhase: TurnPhase.teamGuessing,
        ),
      );
    } else if (state.turnPhase == TurnPhase.teamGuessing) {
      if (!isCorrect) {
        final activeTeam = updatedTeams[state.activeTeamIndex];
        final newTokens = activeTeam.misinterpretationTokens + 1;
        updatedTeams[state.activeTeamIndex] = activeTeam.copyWith(
          misinterpretationTokens: newTokens,
        );
        if (newTokens >= 2) {
          gameStatus = GameStatus.finished;
        }
      }
      // After the team guess, the turn ends.
      // We need to emit the score update first, then start the next turn.
      emit(state.copyWith(teams: updatedTeams, status: gameStatus));
      _startNextTurn();
    }
  }

  void _startNextTurn() {
    // If the game is already finished from the last guess, do nothing more.
    if (state.status == GameStatus.finished) return;

    // Check for end of game by rounds (8 rounds total)
    if (state.currentRound >= 8 && state.activeTeamIndex == 1) {
      emit(state.copyWith(status: GameStatus.finished));
      return;
    }

    // Check for end of game by running out of codes
    if (state.codeDeck.isEmpty) {
      emit(state.copyWith(status: GameStatus.finished));
      return;
    }

    final nextActiveTeamIndex = (state.activeTeamIndex + 1) % 2;
    final nextRound = (nextActiveTeamIndex == 0)
        ? state.currentRound + 1
        : state.currentRound;

    final newCodeDeck = List<String>.from(state.codeDeck);
    final nextCode = newCodeDeck.removeAt(0);

    emit(
      state.copyWith(
        activeTeamIndex: nextActiveTeamIndex,
        currentRound: nextRound,
        turnPhase: TurnPhase.clueGiving,
        codeDeck: newCodeDeck,
        currentCode: nextCode,
        currentClues: [],
      ),
    );
  }
}
