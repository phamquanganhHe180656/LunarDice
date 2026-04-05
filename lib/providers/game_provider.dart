import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/animal.dart';
import '../models/bet.dart';
import '../models/game_state.dart';
import '../shared/constants/app_constants.dart';

/// Provider for the main game state.
final gameProvider =
    StateNotifierProvider<GameNotifier, GameState>((ref) => GameNotifier());

/// Notifier that manages all game logic for Bầu Cua Tôm Cá.
class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(const GameState());

  final Random _random = Random();

  // ── Betting ──────────────────────────────────────────────────────────────

  /// Place or increase a bet on [animalType] by [amount].
  void placeBet(AnimalType animalType, int amount) {
    if (state.phase != GamePhase.betting) return;
    if (amount <= 0) return;
    if (state.balance < amount) return;

    final updatedBets = Map<AnimalType, Bet>.from(state.bets);
    final existing = updatedBets[animalType];
    final newAmount = (existing?.amount ?? 0) + amount;

    updatedBets[animalType] = Bet(animalType: animalType, amount: newAmount);
    state = state.copyWith(
      bets: updatedBets,
      balance: state.balance - amount,
    );
  }

  /// Remove a bet on [animalType] and refund the amount.
  void removeBet(AnimalType animalType) {
    if (state.phase != GamePhase.betting) return;

    final updatedBets = Map<AnimalType, Bet>.from(state.bets);
    final bet = updatedBets.remove(animalType);
    if (bet == null) return;

    state = state.copyWith(
      bets: updatedBets,
      balance: state.balance + bet.amount,
    );
  }

  /// Clear all bets and refund the total amount.
  void clearBets() {
    if (state.phase != GamePhase.betting) return;
    final refund = state.totalBetAmount;
    state = state.copyWith(
      bets: {},
      balance: state.balance + refund,
    );
  }

  // ── Rolling ───────────────────────────────────────────────────────────────

  /// Roll the three dice and transition to the result phase.
  Future<void> rollDice() async {
    if (state.phase != GamePhase.betting) return;
    if (!state.hasBets) return;

    // Transition to rolling phase.
    state = state.copyWith(phase: GamePhase.rolling, diceResults: []);

    await Future.delayed(
        Duration(milliseconds: AppConstants.diceRollDurationMs));

    final results = List.generate(
      3,
      (_) => AnimalType.values[_random.nextInt(AnimalType.values.length)],
    );

    final winAmount = _calculateWinnings(results);

    state = state.copyWith(
      phase: GamePhase.result,
      diceResults: results,
      balance: state.balance + winAmount,
      lastWinAmount: winAmount,
    );
  }

  /// Start a new round.
  void nextRound() {
    if (state.phase != GamePhase.result) return;
    state = state.copyWith(
      phase: GamePhase.betting,
      diceResults: [],
      bets: {},
      lastWinAmount: 0,
      roundNumber: state.roundNumber + 1,
    );
  }

  /// Reset the entire game back to the initial state.
  void resetGame() {
    state = const GameState();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Calculate total winnings based on dice results and placed bets.
  ///
  /// For each animal in [diceResults], if the player has a bet on it, they win
  /// [bet.amount] × (number of dice showing that animal).  Placed bets are NOT
  /// returned as part of this calculation — they were already deducted when
  /// placed.
  int _calculateWinnings(List<AnimalType> results) {
    int winnings = 0;

    for (final entry in state.bets.entries) {
      final animalType = entry.key;
      final bet = entry.value;
      final matches = results.where((r) => r == animalType).length;

      if (matches > 0) {
        // Win bet × matches plus original stake.
        winnings += bet.amount * matches + bet.amount;
      }
    }

    return winnings;
  }
}
