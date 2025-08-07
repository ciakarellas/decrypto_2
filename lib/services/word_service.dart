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

  Future<GameSet> getNewGameSet({String language = 'Polish'}) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> gameSets = await db.query(
      'game_sets',
      where: 'language = ?',
      whereArgs: [language],
      orderBy: 'RANDOM()',
      limit: 1,
    );

    if (gameSets.isEmpty) {
      throw Exception('No game sets found for the selected language.');
    }

    final gameSetData = gameSets.first;

    final List<Map<String, dynamic>> gameSetWords = await db.rawQuery('''
      SELECT w.id, w.word_text
      FROM game_set_words gsw
      JOIN words w ON gsw.word_id = w.id
      WHERE gsw.game_set_id = ?
    ''', [gameSetData['id']]);

    List<MainWord> words = [];
    for (var wordData in gameSetWords) {
      final List<Map<String, dynamic>> hintsData = await db.query(
        'hints',
        where: 'word_id = ?',
        whereArgs: [wordData['id']],
      );

      words.add(
        MainWord(
          id: wordData['id'],
          word: wordData['word_text'],
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

