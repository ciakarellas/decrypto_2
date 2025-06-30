import 'package:decrypto_2/models/main_word.dart';
import 'package:equatable/equatable.dart';

class GameSet extends Equatable {
  const GameSet({required this.mainWords, required this.codes});

  final List<MainWord> mainWords;
  final List<String> codes;

  @override
  List<Object?> get props => [mainWords, codes];
}
