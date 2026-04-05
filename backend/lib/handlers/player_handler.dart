import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../database/db_connection.dart';
import '../database/game_repository.dart';

/// Handles all `/api/players` HTTP endpoints.
class PlayerHandler {
  PlayerHandler(DbConnection db) : _repo = GameRepository(db);

  final GameRepository _repo;

  Router get router {
    final router = Router();

    // GET /api/players/:name
    router.get('/<name>', _getPlayer);

    // POST /api/players
    router.post('/', _createPlayer);

    // PUT /api/players/:id
    router.put('/<id>', _updatePlayer);

    return router;
  }

  Future<Response> _getPlayer(Request request, String name) async {
    try {
      final player = await _repo.findPlayerByName(name);
      if (player == null) {
        return Response.notFound(
          jsonEncode({'error': 'Player not found'}),
          headers: _jsonHeaders,
        );
      }
      return Response.ok(
        jsonEncode(player.toJson()),
        headers: _jsonHeaders,
      );
    } catch (e) {
      return _serverError(e);
    }
  }

  Future<Response> _createPlayer(Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final name = body['name'] as String?;
      final balance = body['balance'] as int? ?? 1000;

      if (name == null || name.trim().isEmpty) {
        return Response(
          400,
          body: jsonEncode({'error': 'name is required'}),
          headers: _jsonHeaders,
        );
      }

      final existing = await _repo.findPlayerByName(name.trim());
      if (existing != null) {
        return Response(
          409,
          body: jsonEncode({'error': 'Player already exists'}),
          headers: _jsonHeaders,
        );
      }

      final player = await _repo.createPlayer(name.trim(), balance: balance);
      return Response(
        201,
        body: jsonEncode(player.toJson()),
        headers: _jsonHeaders,
      );
    } catch (e) {
      return _serverError(e);
    }
  }

  Future<Response> _updatePlayer(Request request, String id) async {
    try {
      final existing = await _repo.findPlayerById(id);
      if (existing == null) {
        return Response.notFound(
          jsonEncode({'error': 'Player not found'}),
          headers: _jsonHeaders,
        );
      }

      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final updated = existing.copyWith(
        balance: body['balance'] as int? ?? existing.balance,
        totalWins: body['totalWins'] as int? ?? existing.totalWins,
        totalLosses: body['totalLosses'] as int? ?? existing.totalLosses,
        gamesPlayed: body['gamesPlayed'] as int? ?? existing.gamesPlayed,
      );

      await _repo.updatePlayer(updated);
      return Response.ok(
        jsonEncode(updated.toJson()),
        headers: _jsonHeaders,
      );
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
