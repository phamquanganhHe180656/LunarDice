/// Application-wide constants for Bầu Cua Tôm Cá.
class AppConstants {
  AppConstants._();

  static const String appName = 'Bầu Cua Tôm Cá';
  static const String appNameShort = 'LunarDice';

  /// Number of dice used in a single round.
  static const int diceCount = 3;

  /// Number of distinct animal faces on the dice.
  static const int animalCount = 6;

  /// Default starting balance for a new player.
  static const int defaultBalance = 1000;

  /// Minimum allowed bet amount.
  static const int minBetAmount = 10;

  /// Maximum allowed bet amount per animal per round.
  static const int maxBetAmount = 500;

  /// Duration (ms) for the dice roll animation.
  static const int diceRollDurationMs = 1200;

  // ── Responsive breakpoints ─────────────────────────────────────────────────

  /// Width threshold below which the layout switches to mobile mode.
  static const double mobileBreakpoint = 600.0;

  /// Width threshold for wide / desktop layouts.
  static const double desktopBreakpoint = 1200.0;
}
