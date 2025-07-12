import 'dart:math';

import 'package:decrypto_2/models/game_set.dart';
import 'package:decrypto_2/models/main_word.dart';

class WordService {
  /// Generates a set of unique codes with 3 unique numbers from 1-4.
  /// Each code contains 3 different numbers, creating multiple possible combinations.
  List<String> _generateCodes() {
    final random = Random();

    // Generate multiple unique codes
    final codeSet = <String>{};

    while (codeSet.length < 8) {
      // Generate 8 codes like the original
      // Create list [1, 2, 3, 4] and shuffle
      final numbers = [1, 2, 3, 4];
      numbers.shuffle(random);

      // Take first 3 numbers to create a code
      final code = numbers.take(3).join('');
      codeSet.add(code);
    }

    return codeSet.toList();
  }

  // A list of pre-defined game sets.
  static final List<GameSet> _gameSets = [
    // Game Set 1: Fantasy / Adventure
    GameSet(
      codes: [], // Will be filled with generated codes
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
      codes: [], // Will be filled with generated codes
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
      codes: [], // Will be filled with generated codes
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
    // Game Set 4: Ocean / Marine
    GameSet(
      codes: [], // Will be filled with generated codes
      words: [
        MainWord(
          word: 'PLACEHOLDER_WORD_1',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_2',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_3',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_4',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
      ],
    ),
    // Game Set 5: Medieval / Knights
    GameSet(
      codes: [], // Will be filled with generated codes
      words: [
        MainWord(
          word: 'PLACEHOLDER_WORD_1',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_2',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_3',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_4',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
      ],
    ),
    // Game Set 6: Technology / Cyberpunk
    GameSet(
      codes: [], // Will be filled with generated codes
      words: [
        MainWord(
          word: 'PLACEHOLDER_WORD_1',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_2',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_3',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_4',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
      ],
    ),
    // Game Set 7: Nature / Wildlife
    GameSet(
      codes: [], // Will be filled with generated codes
      words: [
        MainWord(
          word: 'PLACEHOLDER_WORD_1',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_2',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_3',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_4',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
      ],
    ),
    // Game Set 8: Food / Cooking
    GameSet(
      codes: [], // Will be filled with generated codes
      words: [
        MainWord(
          word: 'PLACEHOLDER_WORD_1',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_2',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_3',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_4',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
      ],
    ),
    // Game Set 9: Sports / Athletics
    GameSet(
      codes: [], // Will be filled with generated codes
      words: [
        MainWord(
          word: 'PLACEHOLDER_WORD_1',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_2',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_3',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_4',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
      ],
    ),
    // Game Set 10: Music / Instruments
    GameSet(
      codes: [], // Will be filled with generated codes
      words: [
        MainWord(
          word: 'PLACEHOLDER_WORD_1',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_2',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_3',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
        MainWord(
          word: 'PLACEHOLDER_WORD_4',
          hints: [
            'HINT_1',
            'HINT_2',
            'HINT_3',
            'HINT_4',
            'HINT_5',
            'HINT_6',
            'HINT_7',
            'HINT_8',
          ],
        ),
      ],
    ),
  ];

  /// Returns a random, complete [GameSet] for a new game with dynamically generated codes.
  GameSet getNewGameSet() {
    final random = Random();
    final selectedGameSet = _gameSets[random.nextInt(_gameSets.length)];

    // Generate fresh codes for this game
    final generatedCodes = _generateCodes();

    // Return a new GameSet with the generated codes
    return GameSet(codes: generatedCodes, words: selectedGameSet.words);
  }
}
