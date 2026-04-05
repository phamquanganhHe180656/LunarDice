import 'animal.dart';
import 'bet.dart';

/// The phase of the current game round.
enum GamePhase { betting, rolling, result }

/// Holds the complete state for a single game round.
class GameState {
  const GameState({
    this.phase = GamePhase.betting,
    this.diceResults = const [],
    this.bets = const {},
    this.balance = 1000,
    this.lastWinAmount = 0,
    this.roundNumber = 1,
  });

  final GamePhase phase;

  /// The three dice outcomes (list of [AnimalType], length 0 or 3).
  final List<AnimalType> diceResults;

  /// Map of animal type to current bet.
  final Map<AnimalType, Bet> bets;

  /// Player's current coin balance.
  final int balance;

  /// Amount won (or lost, if negative) in the last round.
  final int lastWinAmount;

  /// Current round number.
  final int roundNumber;

  /// Whether the player has placed at least one bet.
  bool get hasBets => bets.isNotEmpty;

  /// Total coins wagered this round.
  int get totalBetAmount =>
      bets.values.fold(0, (sum, bet) => sum + bet.amount);

  /// Returns true if the player won anything in the last round.
  bool get isWinner => lastWinAmount > 0;

  GameState copyWith({
    GamePhase? phase,
    List<AnimalType>? diceResults,
    Map<AnimalType, Bet>? bets,
    int? balance,
    int? lastWinAmount,
    int? roundNumber,
  }) {
    return GameState(
      phase: phase ?? this.phase,
      diceResults: diceResults ?? this.diceResults,
      bets: bets ?? this.bets,
      balance: balance ?? this.balance,
      lastWinAmount: lastWinAmount ?? this.lastWinAmount,
      roundNumber: roundNumber ?? this.roundNumber,
    );
  }

  @override
  String toString() =>
      'GameState(phase: $phase, balance: $balance, round: $roundNumber)';
}
