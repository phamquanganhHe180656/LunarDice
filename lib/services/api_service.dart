import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/player.dart';
import '../shared/constants/app_constants.dart';

/// Provider for [ApiService].
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Service that communicates with the Dart/Shelf backend.
class ApiService {
  ApiService({String? baseUrl})
      : _baseUrl = baseUrl ?? const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:8080',
        );

  final String _baseUrl;

  // ── Player endpoints ──────────────────────────────────────────────────────

  /// Fetch an existing player by [name], or create one if not found.
  Future<Player> fetchPlayer(String name) async {
    final uri = Uri.parse('$_baseUrl/api/players/$name');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Player.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else if (response.statusCode == 404) {
      return _createPlayer(name);
    } else {
      throw ApiException(
        'Failed to fetch player: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Create a new player with [name] on the backend.
  Future<Player> _createPlayer(String name) async {
    final uri = Uri.parse('$_baseUrl/api/players');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'balance': AppConstants.defaultBalance}),
    );

    if (response.statusCode == 201) {
      return Player.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw ApiException(
        'Failed to create player: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Update a player's data on the backend.
  Future<void> updatePlayer(Player player) async {
    final uri = Uri.parse('$_baseUrl/api/players/${player.id}');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(player.toJson()),
    );

    if (response.statusCode != 200) {
      throw ApiException(
        'Failed to update player: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  // ── Game endpoints ─────────────────────────────────────────────────────────

  /// Fetch leaderboard (top 10 players by balance).
  Future<List<Player>> fetchLeaderboard() async {
    final uri = Uri.parse('$_baseUrl/api/leaderboard');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data =
          jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        'Failed to fetch leaderboard: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}

/// Exception thrown by [ApiService] on non-successful responses.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
