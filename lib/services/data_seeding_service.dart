import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:decrypto_2/services/database_service.dart';

class DataSeedingService {
  final DatabaseService _databaseService;

  DataSeedingService(this._databaseService);

  Future<void> seedDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    bool isSeeded = prefs.getBool('isSeeded') ?? false;

    if (!isSeeded) {
      await _seedData();
      await prefs.setBool('isSeeded', true);
    }
  }

  Future<void> _seedData() async {
    final db = await _databaseService.database;
    await _seedWordsAndHints(db, 'words/words_polish_3.txt');
    await _seedGameSets(db);
  }

  Future<void> _seedWordsAndHints(Database db, String filePath) async {
    String fileContent = await rootBundle.loadString(filePath);
    LineSplitter ls = const LineSplitter();
    List<String> lines = ls.convert(fileContent);

    for (var line in lines) {
      if (line.isNotEmpty) {
        var parts = line.split(':');
        var word = parts[0].replaceAll('"', '').trim();
        var hints = jsonDecode(parts[1].trim()) as List<dynamic>;

        int wordId = await db.insert('words', {'word_text': word},
            conflictAlgorithm: ConflictAlgorithm.ignore);

        if (wordId != 0) {
          for (var hint in hints) {
            await db.insert('hints', {'word_id': wordId, 'hint_text': hint});
          }
        }
      }
    }
  }

  Future<void> _seedGameSets(Database db) async {
    await defineGameSet(db,
        name: "Fantasy Adventure",
        language: "Polish",
        difficulty: "Easy",
        words: ["Klucz", "Zamek", "Smok", "Miecz"]);
    await defineGameSet(db,
        name: "Space/Sci-Fi",
        language: "Polish",
        difficulty: "Medium",
        words: ["Galaktyka", "Robot", "Kosmita", "Kometa"]);
    await defineGameSet(db,
        name: "Egypt/Desert",
        language: "Polish",
        difficulty: "Hard",
        words: ["Piramida", "Sfinks", "Oaza", "Mumia"]);
  }

  Future<void> defineGameSet(Database db,
      {required String name,
      required String language,
      required String difficulty,
      required List<String> words}) async {
    List<int> wordIds = [];
    for (String wordText in words) {
      List<Map> result = await db.query('words',
          columns: ['id'], where: 'word_text = ?', whereArgs: [wordText]);
      if (result.isNotEmpty) {
        wordIds.add(result.first['id'] as int);
      } else {
        throw Exception('Word not found: $wordText');
      }
    }

    if (wordIds.length == 4) {
      int gameSetId = await db.insert('game_sets', {
        'name': name,
        'language': language,
        'difficulty': difficulty,
      });

      for (int wordId in wordIds) {
        await db.insert('game_set_words', {
          'game_set_id': gameSetId,
          'word_id': wordId,
        });
      }
    }
  }
}
