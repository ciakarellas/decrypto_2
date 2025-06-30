import 'package:equatable/equatable.dart';

import 'package:decrypto_2/models/player.dart';

class Team extends Equatable {
  const Team({
    required this.players,
    required this.secretWords,
    this.clueHistory = const {},
    this.interceptionTokens = 0,
    this.misinterpretationTokens = 0,
  }) : assert(
         secretWords.length == 4,
         'A team must have exactly 4 secret words.',
       );

  final List<Player> players;
  final List<String> secretWords;
  // Maps the secret word index (0-3) to a list of clues given for it.
  final Map<int, List<String>> clueHistory;
  final int interceptionTokens;
  final int misinterpretationTokens;

  Team copyWith({
    List<Player>? players,
    List<String>? secretWords,
    Map<int, List<String>>? clueHistory,
    int? interceptionTokens,
    int? misinterpretationTokens,
  }) {
    return Team(
      players: players ?? this.players,
      secretWords: secretWords ?? this.secretWords,
      clueHistory: clueHistory ?? this.clueHistory,
      interceptionTokens: interceptionTokens ?? this.interceptionTokens,
      misinterpretationTokens:
          misinterpretationTokens ?? this.misinterpretationTokens,
    );
  }

  @override
  List<Object?> get props => [
    players,
    secretWords,
    clueHistory,
    interceptionTokens,
    misinterpretationTokens,
  ];
}
