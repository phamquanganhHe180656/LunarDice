import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../services/api_service.dart';

/// Provider for the current player.
final playerProvider =
    StateNotifierProvider<PlayerNotifier, AsyncValue<Player?>>((ref) {
  return PlayerNotifier(ref.read(apiServiceProvider));
});

/// Notifier that manages the local player profile.
class PlayerNotifier extends StateNotifier<AsyncValue<Player?>> {
  PlayerNotifier(this._apiService) : super(const AsyncValue.data(null));

  final ApiService _apiService;

  /// Load or create a player profile with [name].
  Future<void> loadPlayer(String name) async {
    state = const AsyncValue.loading();
    try {
      final player = await _apiService.fetchPlayer(name);
      state = AsyncValue.data(player);
    } catch (e) {
      // Fall back to a local guest player on error.
      state = AsyncValue.data(
        Player(id: 'guest', name: name),
      );
    }
  }

  /// Update the player's balance locally.
  void updateBalance(int newBalance) {
    state.whenData((player) {
      if (player == null) return;
      state = AsyncValue.data(player.copyWith(balance: newBalance));
    });
  }

  /// Sync the current player data to the backend.
  Future<void> syncPlayer() async {
    final player = state.valueOrNull;
    if (player == null) return;
    try {
      await _apiService.updatePlayer(player);
    } catch (_) {
      // Fail silently — local state is still valid.
    }
  }
}
