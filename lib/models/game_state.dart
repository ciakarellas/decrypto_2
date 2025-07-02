import 'package:equatable/equatable.dart';

enum GameStatus { initial, playing, finished }

class GameState extends Equatable {
  const GameState({
    required this.status,
    required this.secretWords,
    required this.clueHistory,
    required this.playerScore,
    required this.playerLives,
    required this.currentRound,
    required this.currentCode,
    required this.currentClues,
    required this.codeDeck,
  });

  factory GameState.initial() {
    return const GameState(
      status: GameStatus.initial,
      secretWords: [],
      clueHistory: {},
      playerScore: 0,
      playerLives: 2, // Player starts with 2 lives (for 2 wrong guesses)
      currentRound: 0,
      currentCode: '',
      currentClues: [],
      codeDeck: [],
    );
  }

  final GameStatus status;
  final List<String> secretWords;
  final Map<int, List<String>> clueHistory;
  final int playerScore;
  final int playerLives;
  final int currentRound;
  final String currentCode;
  final List<String> currentClues;
  final List<String> codeDeck;

  GameState copyWith({
    GameStatus? status,
    List<String>? secretWords,
    Map<int, List<String>>? clueHistory,
    int? playerScore,
    int? playerLives,
    int? currentRound,
    String? currentCode,
    List<String>? currentClues,
    List<String>? codeDeck,
  }) {
    return GameState(
      status: status ?? this.status,
      secretWords: secretWords ?? this.secretWords,
      clueHistory: clueHistory ?? this.clueHistory,
      playerScore: playerScore ?? this.playerScore,
      playerLives: playerLives ?? this.playerLives,
      currentRound: currentRound ?? this.currentRound,
      currentCode: currentCode ?? this.currentCode,
      currentClues: currentClues ?? this.currentClues,
      codeDeck: codeDeck ?? this.codeDeck,
    );
  }

  @override
  List<Object?> get props => [
    status,
    secretWords,
    clueHistory,
    playerScore,
    playerLives,
    currentRound,
    currentCode,
    currentClues,
    codeDeck,
  ];
}
