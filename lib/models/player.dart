import '../shared/constants/app_constants.dart';

/// Represents a player in the game.
class Player {
  const Player({
    required this.id,
    required this.name,
    this.balance = AppConstants.defaultBalance,
    this.totalWins = 0,
    this.totalLosses = 0,
    this.gamesPlayed = 0,
  });

  final String id;
  final String name;
  final int balance;
  final int totalWins;
  final int totalLosses;
  final int gamesPlayed;

  /// Win rate as a value between 0.0 and 1.0.
  double get winRate =>
      gamesPlayed == 0 ? 0.0 : totalWins.toDouble() / gamesPlayed;

  Player copyWith({
    String? id,
    String? name,
    int? balance,
    int? totalWins,
    int? totalLosses,
    int? gamesPlayed,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'balance': balance,
        'totalWins': totalWins,
        'totalLosses': totalLosses,
        'gamesPlayed': gamesPlayed,
      };

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      balance: json['balance'] as int? ?? AppConstants.defaultBalance,
      totalWins: json['totalWins'] as int? ?? 0,
      totalLosses: json['totalLosses'] as int? ?? 0,
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
    );
  }

  @override
  String toString() => 'Player(id: $id, name: $name, balance: $balance)';
}
