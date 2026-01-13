import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimens.dart';
import '../models/exercice.dart';

class ExerciceListeWidget extends StatelessWidget {
  final Exercice exercice;

  const ExerciceListeWidget({super.key, required this.exercice});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
      ),
      color: AppColors.rougeAcr,
      margin: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description principale
            Text(
              exercice.getDescription(),
              style: const TextStyle(
                color: AppColors.blanc,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Détails
            Text(
              exercice.getDescriptionDetaillee(),
              style: const TextStyle(color: AppColors.blanc, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
