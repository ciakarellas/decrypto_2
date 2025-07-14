import 'package:decrypto_2/utils/app_theme.dart';
import 'package:decrypto_2/views/screens/end_game_screen.dart';
import 'package:decrypto_2/views/screens/game_screen.dart';
import 'package:decrypto_2/services/word_service.dart';
import 'package:decrypto_2/views/screens/home_screen.dart';
import 'package:decrypto_2/views/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decrypto_2/bloc/game/game_cubit.dart';
import 'package:decrypto_2/services/clue_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decrypto',
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/game': (context) => const GameScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/endgame': (context) => BlocProvider.value(
          value: BlocProvider.of<GameCubit>(context),
          child: const EndGameScreen(
            finalScore: 0,
          ), // Placeholder, actual score will be passed via state
        ),
      },
    );
  }
}
