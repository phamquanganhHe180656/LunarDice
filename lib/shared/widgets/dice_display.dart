import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/animal.dart';
import '../../models/game_state.dart';
import '../../providers/game_provider.dart';
import '../../shared/constants/colors.dart';

/// Displays the three dice after a roll, or a placeholder during betting.
class DiceDisplay extends ConsumerWidget {
  const DiceDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return Column(
      children: [
        Text(
          'Xúc Xắc',
          style: TextStyle(
            color: AppColors.textGold,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildDiceFaces(gameState),
        ),
      ],
    );
  }

  List<Widget> _buildDiceFaces(GameState state) {
    if (state.phase == GamePhase.rolling) {
      return List.generate(
        3,
        (_) => _DiceFaceCard(isLoading: true),
      );
    }

    if (state.phase == GamePhase.result && state.diceResults.length == 3) {
      return state.diceResults
          .map((animal) => _DiceFaceCard(animalType: animal))
          .toList();
    }

    // Betting phase — show empty placeholders.
    return List.generate(3, (_) => const _DiceFaceCard());
  }
}

class _DiceFaceCard extends StatelessWidget {
  const _DiceFaceCard({this.animalType, this.isLoading = false});

  final AnimalType? animalType;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: animalType != null
              ? AppColors.primaryGold
              : AppColors.divider,
          width: 2,
        ),
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.primaryGold,
                ),
              )
            : animalType != null
                ? Text(
                    animalType!.emoji,
                    style: const TextStyle(fontSize: 36),
                  )
                : Text(
                    '?',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
      ),
    );
  }
}
