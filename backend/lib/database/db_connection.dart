import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
import '../models/player.dart' show kDefaultBalance;

/// Manages a single MySQL connection used by all handlers.
class DbConnection {
  DbConnection._(this._conn);

  final MySQLConnection _conn;

  MySQLConnection get connection => _conn;

  /// Open and verify the MySQL connection using environment variables.
  ///
  /// Required environment variables:
  /// - `DB_HOST`     (default: localhost)
  /// - `DB_PORT`     (default: 3306)
  /// - `DB_USER`     (default: root)
  /// - `DB_PASSWORD`
  /// - `DB_NAME`     (default: lunar_dice)
  static Future<DbConnection> connect() async {
    final host = Platform.environment['DB_HOST'] ?? 'localhost';
    final port = int.tryParse(Platform.environment['DB_PORT'] ?? '3306') ?? 3306;
    final user = Platform.environment['DB_USER'] ?? 'root';
    final password = Platform.environment['DB_PASSWORD'] ?? '';
    final dbName = Platform.environment['DB_NAME'] ?? 'lunar_dice';

    final conn = await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: dbName,
    );

    await conn.connect();
    await _ensureSchema(conn);

    print('✅ Connected to MySQL at $host:$port/$dbName');
    return DbConnection._(conn);
  }

  /// Create the required tables if they do not already exist.
  static Future<void> _ensureSchema(MySQLConnection conn) async {
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS players (
        id         VARCHAR(36)  NOT NULL PRIMARY KEY,
        name       VARCHAR(100) NOT NULL UNIQUE,
        balance    INT          NOT NULL DEFAULT $kDefaultBalance,
        total_wins INT          NOT NULL DEFAULT 0,
        total_losses INT        NOT NULL DEFAULT 0,
        games_played INT        NOT NULL DEFAULT 0,
        created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await conn.execute('''
      CREATE TABLE IF NOT EXISTS game_rounds (
        id          VARCHAR(36)  NOT NULL PRIMARY KEY,
        player_id   VARCHAR(36)  NOT NULL,
        dice_result VARCHAR(50)  NOT NULL,
        bet_data    JSON         NOT NULL,
        win_amount  INT          NOT NULL DEFAULT 0,
        played_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (player_id) REFERENCES players(id)
      )
    ''');
  }
}
