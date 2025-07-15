### Decrypto Game Flow: A Player's Journey

This document outlines the typical flow of the Decrypto game, from launching the app to finishing a round.

#### 1. Welcome to the Home Screen
When players open the app, they first see the **Home Screen**. This is the central hub where they can:
- Start a new game.
- Navigate to the settings panel.
- View past scores or achievements.

#### 2. Kicking Off a New Game
To start playing, a player initiates a new game from the Home Screen. Here’s what happens behind the scenes:
- **Word Selection**: The game selects a set of secret words for the game session.
- **Game State Initialization**: A new game state is created, tracking everything from the current round number to team scores and the words in play.

#### 3. The Core Gameplay: Clues and Codebreaking
The main action happens on the **Game Screen**. The gameplay is centered around a simple loop:

- **Giving Clues**: One team's "encrypter" draws a card with a code (e.g., 1-4-2) that corresponds to the positions of their secret words. They must provide public clues that guide their teammates to guess the code correctly without being too obvious for the opposing team.
- **Deciphering the Code**:
  - The encrypter's teammates try to match the clues to the correct code (e.g., "animal," "sky," "red" might correspond to words 1, 4, and 2).
  - Simultaneously, the opposing team attempts to "intercept" and guess the code based on the same public clues.
- **Scoring**:
  - If the encrypter's team guesses their code correctly, they get a "Success" token.
  - If the opposing team also guesses the code correctly, they get an "Interception" token.
  - If the encrypter's team fails to guess their own code, they receive a "Failure" token.

This cycle repeats each round, with teams alternating the role of encrypter.

#### 4. Reaching the End Game
A game concludes when one of the following conditions is met:
- A team collects **two "Interception" tokens**, winning the game.
- A team collects **two "Failure" tokens**, losing the game.

Upon conclusion, players are taken to the **End Game Screen**, which displays the final results, declares the winner, and provides options to play again or return to the Home Screen.

#### 5. Customizing the Experience
Players can visit the **Settings Screen** to adjust game parameters. This could include options like:
- Adjusting the difficulty level.
- Managing word packs.
- Changing UI themes.
