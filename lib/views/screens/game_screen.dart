import 'package:decrypto_2/bloc/game/game_state.dart';
import 'package:decrypto_2/bloc/game/game_cubit.dart';
import 'package:decrypto_2/views/screens/end_game_screen.dart';
import 'package:decrypto_2/views/widgets/secret_words_display.dart';
import 'package:decrypto_2/views/widgets/hint_display.dart';
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
                // Round button at the top
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
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
                const SizedBox(height: 40),
                // Center section with 3 hint display areas
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        HintDisplay(
                          label: 'Hint 1',
                          onTap: () {
                            // Handle hint 1 tap
                          },
                        ),
                        HintDisplay(
                          label: 'Hint 2',
                          onTap: () {
                            // Handle hint 2 tap
                          },
                        ),
                        HintDisplay(
                          label: 'Hint 3',
                          onTap: () {
                            // Handle hint 3 tap
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Secret words display at the bottom - 4 widgets in 2 rows
                Column(
                  children: [
                    // First row: Words 1 and 2
                    Row(
                      children: [
                        Expanded(
                          child: SecretWordsDisplay(
                            wordNumber: 1,
                            word: state.secretWords.isNotEmpty
                                ? state.secretWords[0].word
                                : '',
                            showWord: false,
                            hints: state.clueHistory[1] ?? [],
                            onTap: () {
                              // Handle tap on word 1
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SecretWordsDisplay(
                            wordNumber: 2,
                            word: state.secretWords.length > 1
                                ? state.secretWords[1].word
                                : '',
                            showWord: false,
                            hints: state.clueHistory[2] ?? [],
                            onTap: () {
                              // Handle tap on word 2
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Second row: Words 3 and 4
                    Row(
                      children: [
                        Expanded(
                          child: SecretWordsDisplay(
                            wordNumber: 3,
                            word: state.secretWords.length > 2
                                ? state.secretWords[2].word
                                : '',
                            showWord: false,
                            hints: state.clueHistory[3] ?? [],
                            onTap: () {
                              // Handle tap on word 3
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SecretWordsDisplay(
                            wordNumber: 4,
                            word: state.secretWords.length > 3
                                ? state.secretWords[3].word
                                : '',
                            showWord: false,
                            hints: state.clueHistory[4] ?? [],
                            onTap: () {
                              // Handle tap on word 4
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
