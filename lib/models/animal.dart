/// Represents one of the 6 animals in Bầu Cua Tôm Cá.
enum AnimalType { gourd, crab, shrimp, fish, chicken, deer }

/// Extension to provide display name and emoji for each animal.
extension AnimalTypeExtension on AnimalType {
  String get displayName {
    switch (this) {
      case AnimalType.gourd:
        return 'Bầu';
      case AnimalType.crab:
        return 'Cua';
      case AnimalType.shrimp:
        return 'Tôm';
      case AnimalType.fish:
        return 'Cá';
      case AnimalType.chicken:
        return 'Gà';
      case AnimalType.deer:
        return 'Nai';
    }
  }

  String get emoji {
    switch (this) {
      case AnimalType.gourd:
        return '🎃';
      case AnimalType.crab:
        return '🦀';
      case AnimalType.shrimp:
        return '🦐';
      case AnimalType.fish:
        return '🐟';
      case AnimalType.chicken:
        return '🐓';
      case AnimalType.deer:
        return '🦌';
    }
  }

  /// Asset image path for this animal.
  String get imagePath => 'assets/images/${name}.png';

  /// Dice-face index (0–5), matching the order in [AnimalType.values].
  int get faceIndex => AnimalType.values.indexOf(this);
}

/// Model representing a single animal on the betting board.
class Animal {
  const Animal({required this.type});

  final AnimalType type;

  String get name => type.displayName;
  String get emoji => type.emoji;
  String get imagePath => type.imagePath;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Animal && other.type == type;

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() => 'Animal(${type.name})';
}
