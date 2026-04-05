import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/animal.dart';
import '../../models/game_state.dart';
import '../../providers/game_provider.dart';
import '../../providers/bet_provider.dart';
import '../../shared/constants/colors.dart';

/// A single cell on the betting board representing one [AnimalType].
class AnimalCard extends ConsumerWidget {
  const AnimalCard({super.key, required this.animalType});

  final AnimalType animalType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final selectedChip = ref.watch(selectedChipProvider);
    final bet = gameState.bets[animalType];
    final isBetting = gameState.phase == GamePhase.betting;

    final isWinnerAnimal = gameState.phase == GamePhase.result &&
        gameState.diceResults.contains(animalType);

    return GestureDetector(
      onTap: isBetting
          ? () => ref
              .read(gameProvider.notifier)
              .placeBet(animalType, selectedChip)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _cardColor(isWinnerAnimal, bet != null),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isWinnerAnimal
                ? AppColors.primaryGold
                : bet != null
                    ? AppColors.betHighlight
                    : AppColors.divider,
            width: isWinnerAnimal || bet != null ? 2.5 : 1,
          ),
          boxShadow: isWinnerAnimal
              ? [
                  BoxShadow(
                    color: AppColors.primaryGold.withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              animalType.emoji,
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 4),
            Text(
              animalType.displayName,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (bet != null) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.betHighlight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '🪙 ${bet.amount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _cardColor(bool isWinner, bool hasBet) {
    if (isWinner) return AppColors.backgroundCard.withOpacity(0.9);
    if (hasBet) return AppColors.backgroundMedium;
    return AppColors.backgroundCard;
  }
}
