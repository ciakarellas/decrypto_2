# Decrypto Game Development Tasks

This file tracks the development tasks for the Decrypto game. The core loop is: AI gives clues, the user guesses the code.

## Phase 1: Core Gameplay MVP

### 🚀 Project Setup & Foundation (Completed)
- [x] Initialize a new Flutter project and clean up the default counter app.
- [x] Set up the directory structure (`models`, `viewmodels`, `views/screens`, `views/widgets`, `services`, `utils`) as per `GEMINI.md`.
- [x] Add core dependencies to `pubspec.yaml`: `flutter_bloc`, `provider`, `equatable`.
- [x] Configure a basic app theme (colors, fonts) in a central `app_theme.dart` file.
- [x] Set up basic app routing with placeholder screens for home, game, and settings.


## Phase 2: MVP Clue System Refactor ✅ **COMPLETED**

### 🔄 Replace AI with Deterministic Clue System
- [x] **[REFACTOR]** Create new `ClueService` class in `lib/services/clue_service.dart` to replace `AIService`.
- [x] Implement clue tracking mechanism that tracks usage per word without modifying original data.
- [x] Implement `getCluesForCode(String code, List<MainWord> mainWords)` method that uses clues in order (1st, 2nd, 3rd, etc.) based on usage tracking.
- [x] Create deep copy mechanism to preserve original word data integrity.
- [x] Add reset functionality for starting new games with fresh clue tracking.

### 🎲 Code Generation System
- [x] Implement code shuffling mechanism that generates 3 unique numbers from 1-4.
- [x] Create algorithm to shuffle [1, 2, 3, 4] and take first 3 numbers to form code string.
- [x] **[REFACTOR]** Replace predefined codes in `WordService` with dynamic code generation.
- [x] Integrate new code generation into `GameCubit` workflow.

### 📊 Word Service Enhancement
- [x] **[REFACTOR]** Expand `WordService` to support 10 predefined game sets (currently has 3).
- [x] Create empty template structure for 7 additional game sets.
- [x] Maintain existing game set format for consistency.
- [x] Keep `getNewGameSet()` method compatible with new code generation.

### 🔗 Dependency Updates
- [x] **[REFACTOR]** Update `GameCubit` to use `ClueService` instead of `AIService`.
- [x] **[REFACTOR]** Update `main.dart` to instantiate `ClueService()` instead of `AIService()`.
- [x] Remove `ai_service.dart` file completely.
- [x] Update import statements across affected files.

### 🧪 Testing & Validation
- [x] Verify clue selection logic works correctly (e.g., code "143" → clue[0] from word 1, clue[0] from word 4, clue[0] from word 3).
- [x] Test clue progression across multiple rounds (e.g., second usage of word increments clue index).
- [x] Validate that original game set data remains unmodified.
- [x] Test game reset functionality with fresh clue tracking.

## Phase 4: Database Implementation & Seeding

### 🗄️ Task 1: Setup Database Dependencies & Helper
- [ ] Add `sqflite` and `path` packages to `pubspec.yaml`.
- [ ] Create `lib/services/database_service.dart`.
- [ ] Implement a `DatabaseService` class with a singleton pattern to manage a single database instance.
- [ ] Implement an `initDB()` method that opens the database and calls a method to create tables.
- [ ] Define `CREATE TABLE` statements for `game_sets`, `words`, `hints`, and the `game_set_words` junction table based on the agreed schema.

### 🧬 Task 2: Create/Update Data Models
- [ ] Update `lib/models/game_set.dart` to reflect the `game_sets` table structure (e.g., `id`, `name`, `language`, `difficulty`).
- [ ] Update `lib/models/main_word.dart` to include the `id` from the database.
- [ ] Create a `lib/models/hint.dart` model if needed to represent hint data cleanly.

### 📥 Task 3: Implement Data Seeding Mechanism
- [ ] Create a new service: `lib/services/data_seeding_service.dart`.
- [ ] Implement a main `seedDatabase()` method in this service.
- [ ] Add a check within the seeder to ensure it only runs once (e.g., by using `SharedPreferences` or checking if a table is already populated).
- [ ] Implement a file parser to read `words_polish_3.txt` (and later, an English version). The parser should handle the `"word: [hint1, hint2, ...]"` format.
- [ ] Implement logic to insert unique words into the `words` table, avoiding duplicates.
- [ ] Implement logic to insert all associated hints into the `hints` table, correctly linked by `word_id`.
- [ ] Create a hardcoded list/map within the seeder to define your 100 predefined game sets, specifying their `language`, `difficulty`, and the list of `word_text`s they contain.
- [ ] Use this list to populate the `game_sets` table and the `game_set_words` junction table.

### 🔄 Task 4: Refactor WordService to Use Database
- [ ] **[REFACTOR]** Modify `lib/services/word_service.dart` to remove the hardcoded `_gameSets` list.
- [ ] Inject an instance of `DatabaseService` into the `WordService`.
- [ ] **[REFACTOR]** Convert `getNewGameSet()` into an `async` method: `Future<GameSet> getNewGameSet()`.
- [ ] Implement a database query to select a random `game_set_id` based on specified criteria (e.g., language).
- [ ] Implement a query (using a `JOIN`) to fetch the 4 `word_id`s and `word_text`s for the selected `game_set_id`.
- [ ] Implement a query to fetch all `hint_text`s for each of the 4 words.
- [ ] Assemble the fetched data into the `GameSet` and `MainWord` Dart objects to be returned by the method.

### 🚀 Task 5: Integrate Seeding into App Startup
- [ ] **[REFACTOR]** Modify the `main()` function in `lib/main.dart` to be `async`.
- [ ] Call `WidgetsFlutterBinding.ensureInitialized()` at the start of `main()`.
- [ ] Instantiate your `DatabaseService` and call its initialization method.
- [ ] After the database is initialized, instantiate the `DataSeedingService` and call the `seedDatabase()` method.
- [ ] Ensure the app waits for the seeding to complete before launching the main UI.
- [ ] Set up a dependency injection system (like `provider`) to make the `DatabaseService` available to the rest of the app.

### 🛠️ Task 6: Create a Game Set Definition Helper
- [ ] Create a helper function within the `DataSeedingService`, e.g., `defineGameSet({required List<String> words, required String language, required String difficulty, required String name})`.
- [ ] This function will be used internally by the seeder to create each of the 100 predefined sets.
- [ ] **Function Logic:**
    -   It will first query the `words` table to find the IDs for the 4 `word_text` strings provided.
    -   If any of the 4 words are not found in the database, it should throw an error to ensure data integrity.
    -   If all words are found, it will create a new entry in the `game_sets` table with the given `name`, `language`, and `difficulty`.
    -   It will then use the new `game_set_id` and the found `word_id`s to insert the 4 corresponding records into the `game_set_words` junction table.
