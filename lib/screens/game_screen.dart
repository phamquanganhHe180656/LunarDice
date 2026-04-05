import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/bet_provider.dart';
import '../shared/constants/colors.dart';
import '../shared/constants/app_constants.dart';
import '../shared/widgets/betting_board.dart';
import '../shared/widgets/dice_display.dart';
import '../shared/widgets/responsive_layout.dart';

/// Main game screen showing the betting board, dice, and controls.
class GameScreen extends ConsumerWidget {
  const GameScreen({super.key, required this.playerName});

  final String playerName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundMedium,
        title: Text(
          AppConstants.appName,
          style: const TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 4),
                Text(
                  '${gameState.balance}',
                  style: const TextStyle(
                    color: AppColors.textGold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _MobileLayout(playerName: playerName),
        desktop: _DesktopLayout(playerName: playerName),
      ),
    );
  }
}

// ── Mobile Layout ─────────────────────────────────────────────────────────────

class _MobileLayout extends ConsumerWidget {
  const _MobileLayout({required this.playerName});

  final String playerName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PlayerHeader(playerName: playerName),
          const SizedBox(height: 16),
          const DiceDisplay(),
          const SizedBox(height: 16),
          const _ResultBanner(),
          const SizedBox(height: 16),
          const BettingBoard(),
          const SizedBox(height: 16),
          const _ChipSelector(),
          const SizedBox(height: 16),
          const _ActionButtons(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Desktop Layout ────────────────────────────────────────────────────────────

class _DesktopLayout extends ConsumerWidget {
  const _DesktopLayout({required this.playerName});

  final String playerName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left panel: dice + results
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _PlayerHeader(playerName: playerName),
                const SizedBox(height: 24),
                const DiceDisplay(),
                const SizedBox(height: 16),
                const _ResultBanner(),
                const SizedBox(height: 24),
                const _ChipSelector(),
                const SizedBox(height: 24),
                const _ActionButtons(),
              ],
            ),
          ),
        ),
        // Divider
        VerticalDivider(
          color: AppColors.divider,
          thickness: 1,
          width: 1,
        ),
        // Right panel: betting board
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: const BettingBoard(),
          ),
        ),
      ],
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _PlayerHeader extends ConsumerWidget {
  const _PlayerHeader({required this.playerName});

  final String playerName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: AppColors.primaryRed,
          child: Icon(Icons.person, color: AppColors.textLight),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              playerName,
              style: const TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'Vòng ${gameState.roundNumber}',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResultBanner extends ConsumerWidget {
  const _ResultBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    if (gameState.phase != GamePhase.result) return const SizedBox.shrink();

    final won = gameState.lastWinAmount > 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: won ? AppColors.winGreen : AppColors.loseRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        won
            ? '🎉 Thắng! +${gameState.lastWinAmount} 🪙'
            : '😢 Thua! Chúc may mắn lần sau!',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ChipSelector extends ConsumerWidget {
  const _ChipSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChip = ref.watch(selectedChipProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn Mệnh Giá',
          style: TextStyle(
            color: AppColors.textGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: kChipDenominations.map((chip) {
            final isSelected = chip == selectedChip;
            return GestureDetector(
              onTap: () =>
                  ref.read(selectedChipProvider.notifier).state = chip,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGold
                      : AppColors.backgroundMedium,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGold
                        : AppColors.divider,
                  ),
                ),
                child: Text(
                  '$chip',
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.backgroundDark
                        : AppColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);
    final isBetting = gameState.phase == GamePhase.betting;
    final isResult = gameState.phase == GamePhase.result;
    final isRolling = gameState.phase == GamePhase.rolling;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isBetting) ...[
          ElevatedButton.icon(
            onPressed: gameState.hasBets && !isRolling
                ? () => notifier.rollDice()
                : null,
            icon: const Text('🎲', style: TextStyle(fontSize: 20)),
            label: const Text('Lắc Xúc Xắc'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: AppColors.textLight,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: gameState.hasBets ? () => notifier.clearBets() : null,
            icon: const Icon(Icons.clear, color: AppColors.loseRed),
            label: const Text(
              'Xóa Cược',
              style: TextStyle(color: AppColors.loseRed),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.loseRed),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ] else if (isResult) ...[
          ElevatedButton.icon(
            onPressed: () => notifier.nextRound(),
            icon: const Icon(Icons.refresh),
            label: const Text('Vòng Mới'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
              foregroundColor: AppColors.backgroundDark,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => notifier.resetGame(),
            icon: const Icon(Icons.home_outlined),
            label: const Text('Về Trang Chủ'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textMuted,
              side: const BorderSide(color: AppColors.divider),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ] else if (isRolling) ...[
          Center(
            child: Column(
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primaryGold,
                ),
                const SizedBox(height: 12),
                Text(
                  'Đang lắc...',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
