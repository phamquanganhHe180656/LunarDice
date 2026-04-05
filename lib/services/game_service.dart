import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/animal.dart';

/// Provider for [GameService].
final gameServiceProvider = Provider<GameService>((ref) => GameService());

/// Stateless helper service for game-related pure logic.
class GameService {
  final Random _random = Random();

  /// Roll three dice and return the resulting [AnimalType] list.
  List<AnimalType> rollDice() {
    return List.generate(
      3,
      (_) => AnimalType.values[_random.nextInt(AnimalType.values.length)],
    );
  }

  /// Calculate winnings given [bets] (animal → wagered amount) and [results].
  ///
  /// For each animal type in [results], if a bet exists, the player wins:
  ///   bet.amount × occurrences  +  original stake (returned)
  int calculateWinnings(
    Map<AnimalType, int> bets,
    List<AnimalType> results,
  ) {
    int winnings = 0;

    for (final entry in bets.entries) {
      final matches = results.where((r) => r == entry.key).length;
      if (matches > 0) {
        winnings += entry.value * matches + entry.value;
      }
    }

    return winnings;
  }

  /// Returns true if the given [balance] is enough to place [amount].
  bool canAfford(int balance, int amount) => balance >= amount;
}
