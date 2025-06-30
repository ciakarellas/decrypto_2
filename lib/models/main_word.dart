import 'package:equatable/equatable.dart';

class MainWord extends Equatable {
  const MainWord({required this.word, required this.hints});

  final String word;
  final List<String> hints;

  @override
  List<Object?> get props => [word, hints];
}
