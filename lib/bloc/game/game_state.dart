import 'package:equatable/equatable.dart';
import 'package:decrypto_2/models/main_word.dart';

enum GameStatus { initial, playing, finished }

class WordHintPair extends Equatable {
  const WordHintPair({required this.secretWord, required this.hintPosition});

  final int secretWord; // 1-4
  final int hintPosition; // 0-2

  @override
  List<Object> get props => [secretWord, hintPosition];
}

class GameState extends Equatable {
  const GameState({
    this.status = GameStatus.initial,
    this.secretWords = const [],
    this.clueHistory = const {},
    this.playerScore = 0,
    this.roundCount = 0,
    this.successfulGuesses = 0,
    this.currentCode,
    this.currentClues = const [],
    this.pairs = const [],
    this.selectedSecretWord,
    this.showingResults = false,
    this.lastCorrectCode,
  });

  final GameStatus status;
  final List<MainWord> secretWords;
  final Map<int, List<String>> clueHistory;
  final int playerScore;
  final int roundCount;
  final int successfulGuesses;
  final String? currentCode;
  final List<String> currentClues;
  final List<WordHintPair> pairs;
  final int? selectedSecretWord;
  final bool showingResults;
  final String? lastCorrectCode;

  GameState copyWith({
    GameStatus? status,
    List<MainWord>? secretWords,
    Map<int, List<String>>? clueHistory,
    int? playerScore,
    int? roundCount,
    int? successfulGuesses,
    String? currentCode,
    List<String>? currentClues,
    List<WordHintPair>? pairs,
    int? selectedSecretWord,
    bool? showingResults,
    String? lastCorrectCode,
  }) {
    return GameState(
      status: status ?? this.status,
      secretWords: secretWords ?? this.secretWords,
      clueHistory: clueHistory ?? this.clueHistory,
      playerScore: playerScore ?? this.playerScore,
      roundCount: roundCount ?? this.roundCount,
      successfulGuesses: successfulGuesses ?? this.successfulGuesses,
      currentCode: currentCode ?? this.currentCode,
      currentClues: currentClues ?? this.currentClues,
      pairs: pairs ?? this.pairs,
      selectedSecretWord: selectedSecretWord ?? this.selectedSecretWord,
      showingResults: showingResults ?? this.showingResults,
      lastCorrectCode: lastCorrectCode ?? this.lastCorrectCode,
    );
  }

  @override
  List<Object?> get props => [
    status,
    secretWords,
    clueHistory,
    playerScore,
    roundCount,
    successfulGuesses,
    currentCode,
    currentClues,
    pairs,
    selectedSecretWord,
    showingResults,
    lastCorrectCode,
  ];
}
