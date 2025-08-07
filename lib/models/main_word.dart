import 'package:equatable/equatable.dart';
import 'hint.dart';

class MainWord extends Equatable {
  final int? id;
  final String word;
  final List<Hint> hints;

  const MainWord({this.id, required this.word, required this.hints});

  @override
  List<Object?> get props => [id, word, hints];
}
