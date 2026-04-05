import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/animal.dart';

/// Default bet amount increment (chips).
const int kDefaultBetAmount = 50;

/// Available chip denominations.
const List<int> kChipDenominations = [10, 50, 100, 500];

/// Provider for the currently selected chip denomination.
final selectedChipProvider = StateProvider<int>((ref) => kDefaultBetAmount);

/// Provider for the currently highlighted animal on the betting board.
final highlightedAnimalProvider = StateProvider<AnimalType?>((ref) => null);
