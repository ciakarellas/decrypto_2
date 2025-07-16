import 'package:equatable/equatable.dart';
import 'package:decrypto_2/models/main_word.dart';

enum GameStatus { initial, playing, finished }

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
    this.selectedNumbers = const [null, null, null],
    this.selectedWordNumber,
    this.selectedPosition,
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
  final List<int?> selectedNumbers;
  final int? selectedWordNumber;
  final int? selectedPosition;
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
    List<int?>? selectedNumbers,
    int? selectedWordNumber,
    int? selectedPosition,
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
      selectedNumbers: selectedNumbers ?? this.selectedNumbers,
      selectedWordNumber: selectedWordNumber ?? this.selectedWordNumber,
      selectedPosition: selectedPosition ?? this.selectedPosition,
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
    selectedNumbers,
    selectedWordNumber,
    selectedPosition,
    showingResults,
    lastCorrectCode,
  ];
}
