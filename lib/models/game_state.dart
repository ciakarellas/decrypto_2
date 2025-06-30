import 'package:equatable/equatable.dart';

import 'package:decrypto_2/models/team.dart';

enum GameStatus { initial, playing, finished }

enum TurnPhase { clueGiving, interceptGuessing, teamGuessing, roundEnd }

class GameState extends Equatable {
  const GameState({
    required this.teams,
    required this.currentRound,
    required this.status,
    required this.activeTeamIndex,
    required this.turnPhase,
    required this.currentCode,
    required this.currentClues,
    required this.codeDeck,
  });

  factory GameState.initial() {
    return const GameState(
      teams: [],
      currentRound: 0,
      status: GameStatus.initial,
      activeTeamIndex: 0,
      turnPhase: TurnPhase.clueGiving,
      currentCode: '',
      currentClues: [],
      codeDeck: [],
    );
  }

  final List<Team> teams;
  final int currentRound;
  final GameStatus status;
  final int activeTeamIndex;
  final TurnPhase turnPhase;
  final String currentCode;
  final List<String> currentClues;
  final List<String> codeDeck;

  GameState copyWith({
    List<Team>? teams,
    int? currentRound,
    GameStatus? status,
    int? activeTeamIndex,
    TurnPhase? turnPhase,
    String? currentCode,
    List<String>? currentClues,
    List<String>? codeDeck,
  }) {
    return GameState(
      teams: teams ?? this.teams,
      currentRound: currentRound ?? this.currentRound,
      status: status ?? this.status,
      activeTeamIndex: activeTeamIndex ?? this.activeTeamIndex,
      turnPhase: turnPhase ?? this.turnPhase,
      currentCode: currentCode ?? this.currentCode,
      currentClues: currentClues ?? this.currentClues,
      codeDeck: codeDeck ?? this.codeDeck,
    );
  }

  @override
  List<Object?> get props => [
    teams,
    currentRound,
    status,
    activeTeamIndex,
    turnPhase,
    currentCode,
    currentClues,
    codeDeck,
  ];
}
