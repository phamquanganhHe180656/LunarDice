import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import '../lib/database/db_connection.dart';
import '../lib/handlers/game_handler.dart';
import '../lib/handlers/player_handler.dart';

Future<void> main() async {
  // Load environment configuration.
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;

  // Initialise the database connection pool.
  final db = await DbConnection.connect();

  // Build the router.
  final router = Router()
    ..mount('/api/players', PlayerHandler(db).router.call)
    ..mount('/api', GameHandler(db).router.call);

  // Apply middleware.
  final handler = const Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print('🎲 LunarDice server running at http://${server.address.host}:${server.port}');
}
