import 'animal.dart';

/// Represents a player's bet on a single animal.
class Bet {
  const Bet({
    required this.animalType,
    required this.amount,
  }) : assert(amount > 0, 'Bet amount must be positive');

  final AnimalType animalType;
  final int amount;

  /// Returns a new [Bet] with an updated [amount].
  Bet copyWith({AnimalType? animalType, int? amount}) {
    return Bet(
      animalType: animalType ?? this.animalType,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() => {
        'animalType': animalType.name,
        'amount': amount,
      };

  factory Bet.fromJson(Map<String, dynamic> json) {
    return Bet(
      animalType: AnimalType.values.byName(json['animalType'] as String),
      amount: json['amount'] as int,
    );
  }

  @override
  String toString() => 'Bet(animal: ${animalType.name}, amount: $amount)';
}
