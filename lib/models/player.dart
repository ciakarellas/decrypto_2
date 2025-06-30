import 'package:equatable/equatable.dart';

class Player extends Equatable {
  const Player({required this.id, required this.name, this.isAI = false});

  final String id;
  final String name;
  final bool isAI;

  @override
  List<Object?> get props => [id, name, isAI];
}
