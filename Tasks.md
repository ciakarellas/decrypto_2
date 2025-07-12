# Decrypto Game Development Tasks

This file tracks the development tasks for the Decrypto game. The core loop is: AI gives clues, the user guesses the code.

## Phase 1: Core Gameplay MVP

### 🚀 Project Setup & Foundation (Completed)
- [x] Initialize a new Flutter project and clean up the default counter app.
- [x] Set up the directory structure (`models`, `viewmodels`, `views/screens`, `views/widgets`, `services`, `utils`) as per `GEMINI.md`.
- [x] Add core dependencies to `pubspec.yaml`: `flutter_bloc`, `provider`, `equatable`.
- [x] Configure a basic app theme (colors, fonts) in a central `app_theme.dart` file.
- [x] Set up basic app routing with placeholder screens for home, game, and settings.

### 🎨 UI - Screens & Navigation
- [ ] Update `EndGameScreen` to show a final player score (not team-based).
- [x] Refactor `GameScreen` to use `BlocProvider` and `BlocBuilder` to connect to the `GameCubit`.

### 🧱 Core Models
- [x] **[REFACTOR]** Remove `team.dart` and `player.dart` models as they are no longer needed.
- [x] **[REFACTOR]** Rewrite `game_state.dart` to hold the state for a single player: `secretWords`, `clueHistory`, `playerScore`, `playerLives`, `currentCode`, `gameStatus`, etc.
- [ ] Create `main_word.dart` model to group a word with its hints.
- [ ] Create `game_set.dart` model to represent a playable set of words and codes.

### 🧠 Game Logic & State Management (Cubit)
- [ ] **[REFACTOR]** Rewrite `GameCubit` to manage the new `GameState`.
- [ ] **[REFACTOR]** Rewrite `startGame` method: it should get a `GameSet`, set the `secretWords`, initialize `playerScore` and `playerLives`, and trigger the first AI turn.
- [ ] **[REFACTOR]** Rewrite `submitGuess` method: it should take the player's code guess, check correctness, update score or lives, and trigger the next round.
- [ ] Implement a `_triggerAITurn` private method in `GameCubit` that uses the `AIService` to get clues and updates the state.

### 🧩 UI - Gameplay Widgets
- [x] Create a `SecretWordsDisplay` widget that shows the 4 secret words using `WordCard` widgets.
- [ ] Create a `ClueHistoryDisplay` widget to show the clues given by the AI for each word.
- [ ] Create a `CodeInputWidget` for the player to input their 3-digit guess.
- [ ] Create a `PlayerStatusWidget` to display the current score and remaining lives.
- [ ] **[REFACTOR]** Connect all new gameplay widgets within the `GameScreen` to display data from the `GameCubit`.

### 🤖 Basic AI
- [x] Create a basic `AIService` class.
- [x] Implement a method in `AIService` to generate 3 clues based on a given code and word set (e.g., `getCluesForCode(String code, List<MainWord> words)`). For the MVP, this can just be selecting a random hint.
- [x] Integrate the `AIService` into the `GameCubit` so it can be called each round to generate new clues.

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