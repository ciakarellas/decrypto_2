import 'dart:math';

import 'package:decrypto_2/models/game_set.dart';
import 'package:decrypto_2/models/main_word.dart';
import 'package:decrypto_2/models/hint.dart';
import 'package:decrypto_2/services/database_service.dart';

class WordService {
  final DatabaseService _databaseService;

  WordService(this._databaseService);

  List<String> _generateCodes() {
    final random = Random();
    final codeSet = <String>{};

    while (codeSet.length < 8) {
      final numbers = [1, 2, 3, 4];
      numbers.shuffle(random);
      final code = numbers.take(3).join('');
      codeSet.add(code);
    }

    return codeSet.toList();
  }

  Future<GameSet> getNewGameSet() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> gameSets = await db.query('game_sets', where: 'id = ?', whereArgs: [1]);
    final gameSetData = gameSets.first;

    final List<Map<String, dynamic>> gameSetWords = await db.query(
      'game_set_words',
      where: 'game_set_id = ?',
      whereArgs: [gameSetData['id']],
    );

    List<MainWord> words = [];
    for (var gameSetWord in gameSetWords) {
      final List<Map<String, dynamic>> wordData = await db.query('words', where: 'id = ?', whereArgs: [gameSetWord['word_id']]);
      final List<Map<String, dynamic>> hintsData = await db.query('hints', where: 'word_id = ?', whereArgs: [gameSetWord['word_id']]);

      words.add(
        MainWord(
          id: wordData.first['id'],
          word: wordData.first['word_text'],
          hints: hintsData.map((hint) => Hint(id: hint['id'], hintText: hint['hint_text'])).toList(),
        ),
      );
    }

    return GameSet(
      id: gameSetData['id'],
      name: gameSetData['name'],
      language: gameSetData['language'],
      difficulty: gameSetData['difficulty'],
      words: words,
      codes: _generateCodes(),
    );
  }
}

