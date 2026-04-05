import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:uuid/uuid.dart';
import '../database/db_connection.dart';
import '../models/player.dart';

/// Data-access object for the `players` table.
class GameRepository {
  GameRepository(this._db);

  final DbConnection _db;
  final _uuid = const Uuid();

  MySQLConnection get _conn => _db.connection;

  // ── Player CRUD ───────────────────────────────────────────────────────────

  Future<Player?> findPlayerByName(String name) async {
    final result = await _conn.execute(
      'SELECT * FROM players WHERE name = :name LIMIT 1',
      {'name': name},
    );

    if (result.rows.isEmpty) return null;
    return _rowToPlayer(result.rows.first.assoc());
  }

  Future<Player?> findPlayerById(String id) async {
    final result = await _conn.execute(
      'SELECT * FROM players WHERE id = :id LIMIT 1',
      {'id': id},
    );

    if (result.rows.isEmpty) return null;
    return _rowToPlayer(result.rows.first.assoc());
  }

  Future<Player> createPlayer(String name, {int balance = 1000}) async {
    final id = _uuid.v4();
    await _conn.execute(
      '''INSERT INTO players (id, name, balance)
         VALUES (:id, :name, :balance)''',
      {'id': id, 'name': name, 'balance': balance},
    );
    return Player(id: id, name: name, balance: balance);
  }

  Future<void> updatePlayer(Player player) async {
    await _conn.execute(
      '''UPDATE players
         SET balance = :balance,
             total_wins = :total_wins,
             total_losses = :total_losses,
             games_played = :games_played
         WHERE id = :id''',
      {
        'id': player.id,
        'balance': player.balance,
        'total_wins': player.totalWins,
        'total_losses': player.totalLosses,
        'games_played': player.gamesPlayed,
      },
    );
  }

  // ── Leaderboard ──────────────────────────────────────────────────────────

  Future<List<Player>> fetchLeaderboard({int limit = 10}) async {
    final result = await _conn.execute(
      'SELECT * FROM players ORDER BY balance DESC LIMIT :limit',
      {'limit': limit},
    );

    return result.rows
        .map((row) => _rowToPlayer(row.assoc()))
        .toList();
  }

  // ── Game round logging ────────────────────────────────────────────────────

  Future<void> saveRound({
    required String playerId,
    required List<String> diceResult,
    required Map<String, int> betData,
    required int winAmount,
  }) async {
    final id = _uuid.v4();
    await _conn.execute(
      '''INSERT INTO game_rounds (id, player_id, dice_result, bet_data, win_amount)
         VALUES (:id, :player_id, :dice_result, :bet_data, :win_amount)''',
      {
        'id': id,
        'player_id': playerId,
        'dice_result': diceResult.join(','),
        'bet_data': jsonEncode(betData),
        'win_amount': winAmount,
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Player _rowToPlayer(Map<String, String?> row) {
    return Player(
      id: row['id']!,
      name: row['name']!,
      balance: int.parse(row['balance'] ?? '1000'),
      totalWins: int.parse(row['total_wins'] ?? '0'),
      totalLosses: int.parse(row['total_losses'] ?? '0'),
      gamesPlayed: int.parse(row['games_played'] ?? '0'),
    );
  }
}
