import 'package:decrypto_2/bloc/game/game_state.dart';
import 'package:decrypto_2/models/main_word.dart';
import 'package:decrypto_2/bloc/game/game_cubit.dart';
import 'package:decrypto_2/views/screens/end_game_screen.dart';
import 'package:decrypto_2/views/widgets/clue_history_display.dart';
import 'package:decrypto_2/views/widgets/code_input_widget.dart';
import 'package:decrypto_2/views/widgets/player_status_widget.dart';
import 'package:decrypto_2/views/widgets/secret_words_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decrypto Game'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<GameCubit, GameState>(
        listener: (context, state) {
          if (state.status == GameStatus.finished) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EndGameScreen(finalScore: state.playerScore),
                ),
              );
            });
          }
        },
        builder: (context, state) {
          if (state.status == GameStatus.initial || state.secretWords.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SecretWordsDisplay(
                  secretWords: state.secretWords.map((e) => e.word).toList(),
                ),
                const Spacer(),
                CodeInputWidget(
                  onSubmit: (guess) {
                    context.read<GameCubit>().submitGuess(guess);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
