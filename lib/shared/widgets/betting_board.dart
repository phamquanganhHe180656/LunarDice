import 'package:flutter/material.dart';
import '../../models/animal.dart';
import '../../shared/constants/colors.dart';
import 'animal_card.dart';

/// The 2×3 grid betting board showing all 6 animal options.
class BettingBoard extends StatelessWidget {
  const BettingBoard({super.key});

  static const List<AnimalType> _animals = AnimalType.values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Đặt Cược',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textGold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9,
          ),
          itemCount: _animals.length,
          itemBuilder: (_, index) =>
              AnimalCard(animalType: _animals[index]),
        ),
      ],
    );
  }
}
