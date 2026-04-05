import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_dice/models/animal.dart';
import 'package:lunar_dice/models/bet.dart';

void main() {
  group('Bet model', () {
    test('can be created with valid amount', () {
      const bet = Bet(animalType: AnimalType.crab, amount: 100);
      expect(bet.animalType, AnimalType.crab);
      expect(bet.amount, 100);
    });

    test('copyWith returns a new Bet with updated fields', () {
      const original = Bet(animalType: AnimalType.fish, amount: 50);
      final updated = original.copyWith(amount: 200);

      expect(updated.animalType, AnimalType.fish);
      expect(updated.amount, 200);
    });

    test('toJson / fromJson round-trip', () {
      const bet = Bet(animalType: AnimalType.shrimp, amount: 75);
      final json = bet.toJson();
      final restored = Bet.fromJson(json);

      expect(restored.animalType, bet.animalType);
      expect(restored.amount, bet.amount);
    });
  });

  group('AnimalType extension', () {
    test('all animals have a non-empty displayName', () {
      for (final animal in AnimalType.values) {
        expect(animal.displayName, isNotEmpty);
      }
    });

    test('all animals have a non-empty emoji', () {
      for (final animal in AnimalType.values) {
        expect(animal.emoji, isNotEmpty);
      }
    });

    test('all animals have an imagePath', () {
      for (final animal in AnimalType.values) {
        expect(animal.imagePath, contains(animal.name));
      }
    });
  });
}
