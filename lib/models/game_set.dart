import 'package:equatable/equatable.dart';
import 'main_word.dart';

class GameSet extends Equatable {
  final int? id;
  final String name;
  final String language;
  final String difficulty;
  final List<MainWord> words;
  final List<String> codes;

  const GameSet({
    this.id,
    required this.name,
    required this.language,
    required this.difficulty,
    required this.words,
    required this.codes,
  });

  @override
  List<Object?> get props => [id, name, language, difficulty, words, codes];
}