import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_dice/models/animal.dart';
import 'package:lunar_dice/services/game_service.dart';

void main() {
  group('GameService', () {
    late GameService service;

    setUp(() => service = GameService());

    test('rollDice returns a list of 3 AnimalType values', () {
      final results = service.rollDice();
      expect(results.length, 3);
      for (final r in results) {
        expect(AnimalType.values.contains(r), isTrue);
      }
    });

    test('calculateWinnings returns 0 when no bets match', () {
      final winnings = service.calculateWinnings(
        {AnimalType.crab: 100},
        [AnimalType.fish, AnimalType.gourd, AnimalType.deer],
      );
      expect(winnings, 0);
    });

    test('calculateWinnings returns correct amount on a single match', () {
      // Bet 100 on crab; one dice shows crab → win 100 × 1 + 100 stake = 200.
      final winnings = service.calculateWinnings(
        {AnimalType.crab: 100},
        [AnimalType.crab, AnimalType.fish, AnimalType.gourd],
      );
      expect(winnings, 200);
    });

    test('calculateWinnings multiplies by number of matching dice', () {
      // Bet 50 on fish; two dice show fish → win 50 × 2 + 50 stake = 150.
      final winnings = service.calculateWinnings(
        {AnimalType.fish: 50},
        [AnimalType.fish, AnimalType.fish, AnimalType.gourd],
      );
      expect(winnings, 150);
    });

    test('canAfford returns true when balance >= amount', () {
      expect(service.canAfford(500, 500), isTrue);
      expect(service.canAfford(500, 100), isTrue);
    });

    test('canAfford returns false when balance < amount', () {
      expect(service.canAfford(100, 500), isFalse);
    });
  });
}
