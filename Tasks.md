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