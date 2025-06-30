# Decrypto Game Development Tasks

This file tracks the development tasks for the Decrypto game, based on the `prd.md`.

## Phase 1: Core Gameplay MVP

### 🚀 Project Setup & Foundation
- [x] Initialize a new Flutter project and clean up the default counter app.
- [x] Set up the directory structure (`models`, `viewmodels`, `views/screens`, `views/widgets`, `services`, `utils`) as per `GEMINI.md`.
- [x] Add core dependencies to `pubspec.yaml`: `flutter_bloc`, `provider`, `equatable`.
- [x] Configure a basic app theme (colors, fonts) in a central `app_theme.dart` file.
- [x] Set up basic app routing with placeholder screens for home, game, and settings.

### 🎨 UI - Screens & Navigation
- [x] Create a `HomeScreen` widget with "Start Game" and "Settings" buttons.
- [x] Create a placeholder `SettingsScreen` widget accessible from the `HomeScreen`.
- [x] Create a placeholder `GameScreen` widget that will host the main gameplay.
- [x] Create a placeholder `EndGameScreen` to show the final score and a "Play Again" button.
- [x] Implement simple navigation to move between Home -> Game -> EndGame screens.

### 🧱 Core Models
- [x] Create a `player.dart` model with `id`, `name`, and `isAI` properties.
- [x] Create a `team.dart` model containing a list of `Player`s and a list of 4 secret words (as strings).
- [x] Create a `game_state.dart` model to hold the overall game information (e.g., list of teams, current round number, game status).
- [x] Create a `word_service.dart` that provides a hardcoded list of words for the game.

### 🧠 Game Logic & State Management (Cubit)
- [x] Create a `GameCubit` to manage the `GameState`.
- [x] Implement a `startGame` method in `GameCubit` to initialize a single-player game (1 human vs 1 AI team).
- [x] In the `startGame` method, randomly assign 4 words to each team from the `WordService`.
- [x] Implement a `submitClue` method in `GameCubit` that takes a clue from the user.
- [x] Implement a `submitGuess` method in `GameCubit` to handle the player's guess.
- [x] Implement basic score update logic within the `GameCubit`.

### 🧩 UI - Gameplay Widgets
- [ ] Create a `WordCard` widget to display a single word, including a state to show it as hidden.
- [ ] Create a `TeamWordsDisplay` widget that shows the 4 words for a team using `WordCard` widgets.
- [ ] Create a `ClueInputWidget` with a `TextField` and a "Submit" button for the clue-giver.
- [ ] Create a `GuessingWidget` for the guessing team to see clues and input their guess.
- [ ] Create a `ScoreboardWidget` to display the current score for both teams.

### 🤖 Basic AI
- [ ] Create a basic `AIService` class.
- [ ] Implement a method in `AIService` to generate a simple, random clue for one of its words.
- [ ] Implement a method in `AIService` to make a random guess based on the player's clues.
- [ ] Integrate the `AIService` into the `GameCubit` to trigger AI actions on its turn.