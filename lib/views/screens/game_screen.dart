import 'package:decrypto_2/bloc/game/game_state.dart';
import 'package:decrypto_2/bloc/game/game_cubit.dart';
import 'package:decrypto_2/views/screens/end_game_screen.dart';
import 'package:decrypto_2/views/widgets/secret_words_display.dart';
import 'package:decrypto_2/views/widgets/hint_display.dart';
import 'package:decrypto_2/utils/responsive_utils.dart';
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
            padding: ResponsiveUtils.getResponsivePadding(
              context,
              const EdgeInsets.all(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Round button at the top
                Center(
                  child: Container(
                    width: ResponsiveUtils.getRoundButtonSize(context),
                    height: ResponsiveUtils.getRoundButtonSize(context),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: state.showingResults
                          ? Colors.green
                          : Theme.of(context).primaryColor,
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
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getRoundButtonSize(context) / 2,
                        ),
                        onTap: () {
                          if (state.showingResults) {
                            context.read<GameCubit>().startNextRound();
                          }
                        },
                        child: Center(
                          child: state.showingResults
                              ? Text(
                                  'START',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        ResponsiveUtils.getResponsiveFontSize(
                                          context,
                                          18.0,
                                        ),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ROUND',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            ResponsiveUtils.getResponsiveFontSize(
                                              context,
                                              16.0,
                                            ),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          ResponsiveUtils.getResponsiveSpacing(
                                            context,
                                            4.0,
                                          ),
                                    ),
                                    Text(
                                      '${state.roundCount + 1}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            ResponsiveUtils.getResponsiveFontSize(
                                              context,
                                              32.0,
                                            ),
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
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 40.0),
                ),
                // Center section with 3 hint display areas
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Column 1: HintDisplay + Correct digit below
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: ResponsiveUtils.getCorrectDigitHeight(
                                context,
                                ResponsiveUtils.getResponsiveFontSize(
                                  context,
                                  32.0,
                                ),
                              ),
                              margin: EdgeInsets.only(
                                top: ResponsiveUtils.getResponsiveSpacing(
                                  context,
                                  8.0,
                                ),
                              ),
                              child: Text(
                                (state.showingResults &&
                                        state.lastCorrectCode != null &&
                                        state.lastCorrectCode!.isNotEmpty)
                                    ? state.lastCorrectCode![0]
                                    : '',
                                style: TextStyle(
                                  color:
                                      (state.showingResults &&
                                          state.lastCorrectCode != null &&
                                          state.lastCorrectCode!.isNotEmpty)
                                      ? Colors.green
                                      : Colors.transparent,
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                        context,
                                        32.0,
                                      ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            HintDisplay(
                              label: 'Hint 1',
                              hint: state.currentClues.isNotEmpty
                                  ? state.currentClues[0]
                                  : null,
                              selectedNumber: state.pairs
                                  .where((pair) => pair.hintPosition == 0)
                                  .firstOrNull
                                  ?.secretWord,
                              isPaired: state.pairs.any(
                                (pair) => pair.hintPosition == 0,
                              ),
                              isCorrect:
                                  state.showingResults &&
                                      state.pairs
                                              .where(
                                                (pair) =>
                                                    pair.hintPosition == 0,
                                              )
                                              .firstOrNull
                                              ?.secretWord !=
                                          null &&
                                      state.lastCorrectCode != null &&
                                      state.lastCorrectCode!.isNotEmpty
                                  ? state.pairs
                                            .where(
                                              (pair) => pair.hintPosition == 0,
                                            )
                                            .firstOrNull!
                                            .secretWord ==
                                        int.parse(state.lastCorrectCode![0])
                                  : null,
                              onTap: state.showingResults
                                  ? null
                                  : () {
                                      context.read<GameCubit>().selectPosition(
                                        0,
                                      );
                                    },
                            ),

                            // Show correct digit below HintDisplay when showing results
                          ],
                        ),
                        // Column 2: HintDisplay + Correct digit below
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: ResponsiveUtils.getCorrectDigitHeight(
                                context,
                                ResponsiveUtils.getResponsiveFontSize(
                                  context,
                                  32.0,
                                ),
                              ),
                              margin: EdgeInsets.only(
                                top: ResponsiveUtils.getResponsiveSpacing(
                                  context,
                                  8.0,
                                ),
                              ),
                              child: Text(
                                (state.showingResults &&
                                        state.lastCorrectCode != null &&
                                        state.lastCorrectCode!.length > 1)
                                    ? state.lastCorrectCode![1]
                                    : '',
                                style: TextStyle(
                                  color:
                                      (state.showingResults &&
                                          state.lastCorrectCode != null &&
                                          state.lastCorrectCode!.length > 1)
                                      ? Colors.green
                                      : Colors.transparent,
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                        context,
                                        32.0,
                                      ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            HintDisplay(
                              label: 'Hint 2',
                              hint: state.currentClues.length > 1
                                  ? state.currentClues[1]
                                  : null,
                              selectedNumber: state.pairs
                                  .where((pair) => pair.hintPosition == 1)
                                  .firstOrNull
                                  ?.secretWord,
                              isPaired: state.pairs.any(
                                (pair) => pair.hintPosition == 1,
                              ),
                              isCorrect:
                                  state.showingResults &&
                                      state.pairs
                                              .where(
                                                (pair) =>
                                                    pair.hintPosition == 1,
                                              )
                                              .firstOrNull
                                              ?.secretWord !=
                                          null &&
                                      state.lastCorrectCode != null &&
                                      state.lastCorrectCode!.length > 1
                                  ? state.pairs
                                            .where(
                                              (pair) => pair.hintPosition == 1,
                                            )
                                            .firstOrNull!
                                            .secretWord ==
                                        int.parse(state.lastCorrectCode![1])
                                  : null,
                              onTap: state.showingResults
                                  ? null
                                  : () {
                                      context.read<GameCubit>().selectPosition(
                                        1,
                                      );
                                    },
                            ),
                          ],
                        ),
                        // Column 3: HintDisplay + Correct digit below
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: ResponsiveUtils.getCorrectDigitHeight(
                                context,
                                ResponsiveUtils.getResponsiveFontSize(
                                  context,
                                  32.0,
                                ),
                              ),
                              margin: EdgeInsets.only(
                                top: ResponsiveUtils.getResponsiveSpacing(
                                  context,
                                  8.0,
                                ),
                              ),
                              child: Text(
                                (state.showingResults &&
                                        state.lastCorrectCode != null &&
                                        state.lastCorrectCode!.length > 2)
                                    ? state.lastCorrectCode![2]
                                    : '',
                                style: TextStyle(
                                  color:
                                      (state.showingResults &&
                                          state.lastCorrectCode != null &&
                                          state.lastCorrectCode!.length > 2)
                                      ? Colors.green
                                      : Colors.transparent,
                                  fontSize:
                                      ResponsiveUtils.getResponsiveFontSize(
                                        context,
                                        32.0,
                                      ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            HintDisplay(
                              label: 'Hint 3',
                              hint: state.currentClues.length > 2
                                  ? state.currentClues[2]
                                  : null,
                              selectedNumber: state.pairs
                                  .where((pair) => pair.hintPosition == 2)
                                  .firstOrNull
                                  ?.secretWord,
                              isPaired: state.pairs.any(
                                (pair) => pair.hintPosition == 2,
                              ),
                              isCorrect:
                                  state.showingResults &&
                                      state.pairs
                                              .where(
                                                (pair) =>
                                                    pair.hintPosition == 2,
                                              )
                                              .firstOrNull
                                              ?.secretWord !=
                                          null &&
                                      state.lastCorrectCode != null &&
                                      state.lastCorrectCode!.length > 2
                                  ? state.pairs
                                            .where(
                                              (pair) => pair.hintPosition == 2,
                                            )
                                            .firstOrNull!
                                            .secretWord ==
                                        int.parse(state.lastCorrectCode![2])
                                  : null,
                              onTap: state.showingResults
                                  ? null
                                  : () {
                                      context.read<GameCubit>().selectPosition(
                                        2,
                                      );
                                    },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 20.0),
                ),
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
                            hints: state.clueHistory[0] ?? [],
                            isSelected: state.selectedSecretWord == 1,
                            isPaired: state.pairs.any(
                              (pair) => pair.secretWord == 1,
                            ),
                            onTap: state.showingResults
                                ? null
                                : () {
                                    context.read<GameCubit>().selectWord(1);
                                  },
                          ),
                        ),
                        SizedBox(
                          width: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            12.0,
                          ),
                        ),
                        Expanded(
                          child: SecretWordsDisplay(
                            wordNumber: 2,
                            word: state.secretWords.length > 1
                                ? state.secretWords[1].word
                                : '',
                            showWord: false,
                            hints: state.clueHistory[1] ?? [],
                            isSelected: state.selectedSecretWord == 2,
                            isPaired: state.pairs.any(
                              (pair) => pair.secretWord == 2,
                            ),
                            onTap: state.showingResults
                                ? null
                                : () {
                                    context.read<GameCubit>().selectWord(2);
                                  },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(
                        context,
                        12.0,
                      ),
                    ),
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
                            hints: state.clueHistory[2] ?? [],
                            isSelected: state.selectedSecretWord == 3,
                            isPaired: state.pairs.any(
                              (pair) => pair.secretWord == 3,
                            ),
                            onTap: state.showingResults
                                ? null
                                : () {
                                    context.read<GameCubit>().selectWord(3);
                                  },
                          ),
                        ),
                        SizedBox(
                          width: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            12.0,
                          ),
                        ),
                        Expanded(
                          child: SecretWordsDisplay(
                            wordNumber: 4,
                            word: state.secretWords.length > 3
                                ? state.secretWords[3].word
                                : '',
                            showWord: false,
                            hints: state.clueHistory[3] ?? [],
                            isSelected: state.selectedSecretWord == 4,
                            isPaired: state.pairs.any(
                              (pair) => pair.secretWord == 4,
                            ),
                            onTap: state.showingResults
                                ? null
                                : () {
                                    context.read<GameCubit>().selectWord(4);
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
