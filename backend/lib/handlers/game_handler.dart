import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../database/db_connection.dart';
import '../database/game_repository.dart';

/// Handles game-related endpoints (leaderboard, round recording).
class GameHandler {
  GameHandler(DbConnection db) : _repo = GameRepository(db);

  final GameRepository _repo;

  Router get router {
    final router = Router();

    // GET /api/leaderboard
    router.get('/leaderboard', _getLeaderboard);

    // POST /api/rounds
    router.post('/rounds', _saveRound);

    return router;
  }

  Future<Response> _getLeaderboard(Request request) async {
    try {
      final players = await _repo.fetchLeaderboard();
      return Response.ok(
        jsonEncode(players.map((p) => p.toJson()).toList()),
        headers: _jsonHeaders,
      );
    } catch (e) {
      return _serverError(e);
    }
  }

  Future<Response> _saveRound(Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final playerId = body['playerId'] as String?;
      final diceResult =
          (body['diceResult'] as List<dynamic>?)?.cast<String>() ?? [];
      final betData =
          (body['betData'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          {};
      final winAmount = body['winAmount'] as int? ?? 0;

      if (playerId == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'playerId is required'}),
          headers: _jsonHeaders,
        );
      }

      await _repo.saveRound(
        playerId: playerId,
        diceResult: diceResult,
        betData: betData,
        winAmount: winAmount,
      );

      return Response(201, body: jsonEncode({'ok': true}), headers: _jsonHeaders);
    } catch (e) {
      return _serverError(e);
    }
  }

  Response _serverError(Object e) {
    return Response.internalServerError(
      body: jsonEncode({'error': e.toString()}),
      headers: _jsonHeaders,
    );
  }

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
  };
}
