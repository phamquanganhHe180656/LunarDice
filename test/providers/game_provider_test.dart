import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunar_dice/models/animal.dart';
import 'package:lunar_dice/models/game_state.dart';
import 'package:lunar_dice/providers/game_provider.dart';

void main() {
  group('GameNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has correct defaults', () {
      final state = container.read(gameProvider);
      expect(state.phase, GamePhase.betting);
      expect(state.balance, 1000);
      expect(state.bets, isEmpty);
      expect(state.roundNumber, 1);
    });

    test('placeBet adds a bet and deducts balance', () {
      final notifier = container.read(gameProvider.notifier);
      notifier.placeBet(AnimalType.crab, 100);

      final state = container.read(gameProvider);
      expect(state.bets.containsKey(AnimalType.crab), isTrue);
      expect(state.bets[AnimalType.crab]!.amount, 100);
      expect(state.balance, 900);
    });

    test('placeBet accumulates on the same animal', () {
      final notifier = container.read(gameProvider.notifier);
      notifier.placeBet(AnimalType.fish, 50);
      notifier.placeBet(AnimalType.fish, 50);

      final state = container.read(gameProvider);
      expect(state.bets[AnimalType.fish]!.amount, 100);
      expect(state.balance, 900);
    });

    test('removeBet refunds the bet amount', () {
      final notifier = container.read(gameProvider.notifier);
      notifier.placeBet(AnimalType.deer, 200);
      notifier.removeBet(AnimalType.deer);

      final state = container.read(gameProvider);
      expect(state.bets, isEmpty);
      expect(state.balance, 1000);
    });

    test('clearBets removes all bets and refunds total', () {
      final notifier = container.read(gameProvider.notifier);
      notifier.placeBet(AnimalType.gourd, 100);
      notifier.placeBet(AnimalType.chicken, 150);
      notifier.clearBets();

      final state = container.read(gameProvider);
      expect(state.bets, isEmpty);
      expect(state.balance, 1000);
    });

    test('placeBet does nothing if balance is insufficient', () {
      final notifier = container.read(gameProvider.notifier);
      notifier.placeBet(AnimalType.crab, 5000); // More than default 1000.

      final state = container.read(gameProvider);
      expect(state.bets, isEmpty);
      expect(state.balance, 1000);
    });

    test('nextRound increments round number and resets bets', () async {
      final notifier = container.read(gameProvider.notifier);
      notifier.placeBet(AnimalType.shrimp, 50);
      await notifier.rollDice();
      notifier.nextRound();

      final state = container.read(gameProvider);
      expect(state.roundNumber, 2);
      expect(state.phase, GamePhase.betting);
      expect(state.bets, isEmpty);
    });

    test('resetGame restores initial state', () async {
      final notifier = container.read(gameProvider.notifier);
      notifier.placeBet(AnimalType.crab, 100);
      await notifier.rollDice();
      notifier.resetGame();

      final state = container.read(gameProvider);
      expect(state.phase, GamePhase.betting);
      expect(state.balance, 1000);
      expect(state.roundNumber, 1);
    });
  });
}
