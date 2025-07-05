import 'dart:math';

import 'package:decrypto_2/models/game_set.dart';
import 'package:decrypto_2/models/main_word.dart';

class WordService {
  // The deck of 8 code cards used in the game.
  static const List<String> _codes = [
    '123',
    '134',
    '142',
    '214',
    '231',
    '312',
    '341',
    '423',
  ];

  // A list of pre-defined game sets.
  static final List<GameSet> _gameSets = [
    // Game Set 1: Fantasy / Adventure
    GameSet(
      codes: _codes,
      words: [
        MainWord(
          word: 'CASTLE',
          hints: [
            'FORTRESS',
            'TOWER',
            'KING',
            'QUEEN',
            'MOAT',
            'DRAWBRIDGE',
            'KNIGHT',
            'PRINCESS',
          ],
        ),
        MainWord(
          word: 'DRAGON',
          hints: [
            'FIRE',
            'WINGS',
            'SCALES',
            'MYTH',
            'LIZARD',
            'TREASURE',
            'REPTILE',
            'BEAST',
          ],
        ),
        MainWord(
          word: 'WIZARD',
          hints: [
            'MAGIC',
            'SPELL',
            'STAFF',
            'ROBE',
            'BEARD',
            'POTION',
            'SORCERER',
            'HAT',
          ],
        ),
        MainWord(
          word: 'FOREST',
          hints: [
            'TREES',
            'WOODS',
            'PATH',
            'LEAVES',
            'GREEN',
            'NATURE',
            'HIKE',
            'CAMP',
          ],
        ),
      ],
    ),
    // Game Set 2: Space / Sci-Fi
    GameSet(
      codes: _codes,
      words: [
        MainWord(
          word: 'GALAXY',
          hints: [
            'STARS',
            'NEBULA',
            'UNIVERSE',
            'SPIRAL',
            'MILKY-WAY',
            'SPACE',
            'PLANET',
            'COSMOS',
          ],
        ),
        MainWord(
          word: 'ROBOT',
          hints: [
            'ANDROID',
            'CYBORG',
            'MACHINE',
            'AUTOMATON',
            'METAL',
            'WIRES',
            'AI',
            'GEARS',
          ],
        ),
        MainWord(
          word: 'ALIEN',
          hints: [
            'EXTRATERRESTRIAL',
            'UFO',
            'MARTIAN',
            'INVASION',
            'CREATURE',
            'VISITOR',
            'SPACESHIP',
            'GREEN',
          ],
        ),
        MainWord(
          word: 'COMET',
          hints: [
            'TAIL',
            'ICE',
            'ROCK',
            'ORBIT',
            'HALLEY',
            'ASTEROID',
            'METEOR',
            'SKY',
          ],
        ),
      ],
    ),
    // Game Set 3: Egypt / Desert
    GameSet(
      codes: _codes,
      words: [
        MainWord(
          word: 'PYRAMID',
          hints: [
            'TRIANGLE',
            'TOMB',
            'PHARAOH',
            'GIZA',
            'STONE',
            'ANCIENT',
            'EGYPT',
            'MONUMENT',
          ],
        ),
        MainWord(
          word: 'SPHINX',
          hints: [
            'LION',
            'RIDDLE',
            'STATUE',
            'MYSTERY',
            'PAWS',
            'HEAD',
            'SAND',
            'LEGEND',
          ],
        ),
        MainWord(
          word: 'OASIS',
          hints: [
            'WATER',
            'PALM-TREE',
            'DESERT',
            'REFUGE',
            'MIRAGE',
            'SPRING',
            'GREEN',
            'SHELTER',
          ],
        ),
        MainWord(
          word: 'MUMMY',
          hints: [
            'BANDAGES',
            'CURSE',
            'SARCOPHAGUS',
            'UNDEAD',
            'TOMB',
            'WRAPPED',
            'PRESERVED',
            'ANCIENT',
          ],
        ),
      ],
    ),
  ];

  /// Returns a random, complete [GameSet] for a new game.
  GameSet getNewGameSet() {
    final random = Random();
    return _gameSets[random.nextInt(_gameSets.length)];
  }
}
