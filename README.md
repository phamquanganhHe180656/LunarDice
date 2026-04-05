# LunarDice 🎲

A modern cross-platform recreation of the traditional Vietnamese folk game **"Bầu Cua Tôm Cá"** (Gourd-Crab-Shrimp-Fish).  
Built with **Flutter & Dart**, backed by a **Dart/Shelf** server connected to **MySQL**, deployable on a Raspberry Pi via Tailscale VPN.

---

## Project structure

```
LunarDice/
├── lib/                         # Flutter application
│   ├── main.dart                # Entry point (ProviderScope → MaterialApp)
│   ├── models/                  # Plain-Dart data models
│   │   ├── animal.dart          # AnimalType enum + extensions
│   │   ├── bet.dart             # Single bet (animal + amount)
│   │   ├── game_state.dart      # Immutable game-round state
│   │   └── player.dart          # Player profile model
│   ├── providers/               # Riverpod state management
│   │   ├── game_provider.dart   # GameNotifier — core game logic
│   │   ├── bet_provider.dart    # Chip selector & board highlights
│   │   └── player_provider.dart # Player profile + backend sync
│   ├── services/                # Business logic & API calls
│   │   ├── api_service.dart     # HTTP client for the Shelf backend
│   │   └── game_service.dart    # Pure helpers (dice roll, winnings)
│   ├── screens/                 # Full-page widgets
│   │   ├── home_screen.dart     # Name-entry lobby
│   │   └── game_screen.dart     # Main game (responsive mobile/desktop)
│   └── shared/
│       ├── widgets/             # Reusable UI components
│       │   ├── animal_card.dart     # Single animal tile on the board
│       │   ├── betting_board.dart   # 2×3 grid of all 6 animals
│       │   ├── dice_display.dart    # 3-dice result display
│       │   └── responsive_layout.dart # Mobile / desktop switcher
│       └── constants/
│           ├── colors.dart          # Brand colour palette
│           └── app_constants.dart   # Numeric & string constants
├── backend/                     # Dart/Shelf HTTP server
│   ├── bin/server.dart          # Server entry point
│   └── lib/
│       ├── database/            # MySQL connection & queries
│       ├── handlers/            # REST route handlers
│       └── models/              # Serialisable server-side models
├── assets/images/               # Animal artwork (PNG)
├── web/                         # Web-specific files (index.html, manifest)
└── test/                        # Unit & widget tests
```

## Getting started

### Flutter app

```bash
flutter pub get
flutter run                # Mobile
flutter run -d chrome      # Web
```

### Backend server

```bash
cd backend
dart pub get
DB_PASSWORD=secret dart run bin/server.dart
```

See [`backend/README.md`](backend/README.md) for full environment-variable reference.

## Animals

| Emoji | Vietnamese | English  |
|-------|-----------|----------|
| 🎃    | Bầu       | Gourd    |
| 🦀    | Cua       | Crab     |
| 🦐    | Tôm       | Shrimp   |
| 🐟    | Cá        | Fish     |
| 🐓    | Gà        | Chicken  |
| 🦌    | Nai       | Deer     |

## Tech stack

| Layer       | Technology                        |
|-------------|-----------------------------------|
| UI          | Flutter 3 (Material 3)            |
| State       | Riverpod 2 (StateNotifier)        |
| Networking  | `package:http`                    |
| Backend     | Dart · Shelf · shelf_router       |
| Database    | MySQL (`package:mysql_client`)    |
| Deployment  | Raspberry Pi · Tailscale VPN      |
