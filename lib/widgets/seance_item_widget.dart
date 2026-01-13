import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../constants/dimens.dart';
import '../models/seance.dart';

class SeanceItemWidget extends StatelessWidget {
  final Seance seance;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const SeanceItemWidget({
    super.key,
    required this.seance,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // Formater la date
    DateFormat sdf = DateFormat("dd/MM/yyyy HH:mm");
    String dateFormatted = sdf.format(seance.dateCreation);

    // Limiter le résumé
    String resume = seance.getResume();
    if (resume.length > 100) {
      resume = '${resume.substring(0, 97)}...';
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
      ),
      color: AppColors.blanc,
      margin: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom de la séance
              Text(
                seance.nom,
                style: const TextStyle(
                  color: AppColors.noir,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Date et nombre d'exercices
              Row(
                children: [
                  Text(
                    dateFormatted,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${seance.exercices.length} exercice(s)',
                    style: TextStyle(
                      color: AppColors.rougeAcr,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Résumé des exercices
              Text(
                resume,
                style: const TextStyle(color: AppColors.noir, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
