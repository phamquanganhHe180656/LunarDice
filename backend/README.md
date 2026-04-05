# LunarDice — Backend

A lightweight **Dart/Shelf** HTTP server that connects the Flutter app to a **MySQL** database.

## Architecture

```
backend/
├── bin/
│   └── server.dart          # Entry point — starts the Shelf server
└── lib/
    ├── database/
    │   ├── db_connection.dart   # MySQL connection + schema bootstrap
    │   └── game_repository.dart # All DB queries (players, rounds)
    ├── handlers/
    │   ├── player_handler.dart  # REST routes for /api/players
    │   └── game_handler.dart    # REST routes for /api/leaderboard, /api/rounds
    └── models/
        └── player.dart          # Serialisable player model
```

## Environment variables

| Variable      | Default       | Description                      |
|---------------|---------------|----------------------------------|
| `PORT`        | `8080`        | Port the server listens on       |
| `DB_HOST`     | `localhost`   | MySQL host                       |
| `DB_PORT`     | `3306`        | MySQL port                       |
| `DB_USER`     | `root`        | MySQL username                   |
| `DB_PASSWORD` | *(empty)*     | MySQL password                   |
| `DB_NAME`     | `lunar_dice`  | MySQL database name              |

## Running locally

```bash
cd backend
dart pub get
dart run bin/server.dart
```

## API endpoints

| Method | Path                    | Description                       |
|--------|-------------------------|-----------------------------------|
| GET    | `/api/players/:name`    | Get player by username            |
| POST   | `/api/players`          | Create a new player               |
| PUT    | `/api/players/:id`      | Update player data                |
| GET    | `/api/leaderboard`      | Top 10 players by balance         |
| POST   | `/api/rounds`           | Record a completed game round     |
