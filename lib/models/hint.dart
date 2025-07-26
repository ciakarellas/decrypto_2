import 'package:equatable/equatable.dart';

class Hint extends Equatable {
  final int? id;
  final String hintText;

  const Hint({this.id, required this.hintText});

  @override
  List<Object?> get props => [id, hintText];
}
