import 'package:equatable/equatable.dart';
import 'package:decrypto_2/models/main_word.dart';

enum GameStatus { initial, playing, finished }

class GameState extends Equatable {
  const GameState({
    this.status = GameStatus.initial,
    this.secretWords = const [],
    this.clueHistory = const {},
    this.playerScore = 0,
    this.playerLives = 2,
    this.currentCode,
    this.currentClues = const [],
  });

  final GameStatus status;
  final List<MainWord> secretWords;
  final Map<int, List<String>> clueHistory;
  final int playerScore;
  final int playerLives;
  final String? currentCode;
  final List<String> currentClues;

  GameState copyWith({
    GameStatus? status,
    List<MainWord>? secretWords,
    Map<int, List<String>>? clueHistory,
    int? playerScore,
    int? playerLives,
    String? currentCode,
    List<String>? currentClues,
  }) {
    return GameState(
      status: status ?? this.status,
      secretWords: secretWords ?? this.secretWords,
      clueHistory: clueHistory ?? this.clueHistory,
      playerScore: playerScore ?? this.playerScore,
      playerLives: playerLives ?? this.playerLives,
      currentCode: currentCode ?? this.currentCode,
      currentClues: currentClues ?? this.currentClues,
    );
  }

  @override
  List<Object?> get props => [
        status,
        secretWords,
        clueHistory,
        playerScore,
        playerLives,
        currentCode,
        currentClues,
      ];
}
