import 'package:decrypto_2/services/data_seeding_service.dart';
import 'package:decrypto_2/services/database_service.dart';
import 'package:decrypto_2/utils/app_theme.dart';
import 'package:decrypto_2/views/screens/end_game_screen.dart';
import 'package:decrypto_2/views/screens/game_screen.dart';
import 'package:decrypto_2/views/screens/home_screen.dart';
import 'package:decrypto_2/views/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decrypto_2/bloc/game/game_cubit.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = DatabaseService();
  await databaseService.database; // Ensures DB is initialized
  await DataSeedingService(databaseService).seedDatabase();

  runApp(MyApp(databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;

  const MyApp({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return Provider<DatabaseService>.value(
      value: databaseService,
      child: MaterialApp(
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
      ),
    );
  }
}
