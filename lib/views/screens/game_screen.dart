import 'package:decrypto_2/bloc/game/game_state.dart';
import 'package:decrypto_2/bloc/game/game_cubit.dart';
import 'package:decrypto_2/views/screens/end_game_screen.dart';
import 'package:decrypto_2/views/widgets/code_input_widget.dart';
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
                  showWords:
                      false, // Words are hidden initially as per Decrypto rules
                  clueHistory: state.clueHistory,
                ),
                const Spacer(),
                // Round button in the center
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(60),
                        onTap: () {},
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ROUND',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${state.roundCount + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
