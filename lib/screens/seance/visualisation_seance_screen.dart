import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/dimens.dart';
import '../../models/seance.dart';
import '../../widgets/exercice_liste_widget.dart';

class VisualisationSeanceScreen extends StatelessWidget {
  final Seance seance;

  const VisualisationSeanceScreen({super.key, required this.seance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blanc,
      body: Column(
        children: [
          // Titre fixe
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: AppDimens.paddingLarge,
              right: AppDimens.paddingLarge,
            ),
            decoration: BoxDecoration(
              color: AppColors.rougeAcr,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              'Séance créée',
              style: TextStyle(
                color: AppColors.blanc,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Contenu défilant
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom de la séance
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimens.paddingLarge),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.rougeAcr, width: 2),
                      borderRadius: BorderRadius.circular(
                        AppDimens.borderRadiusMedium,
                      ),
                    ),
                    child: Text(
                      seance.nom,
                      style: const TextStyle(
                        color: AppColors.rougeAcr,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Titre exercices
                  Text(
                    'Exercices :',
                    style: TextStyle(
                      color: AppColors.rougeAcrDark,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Liste des exercices
                  if (seance.exercices.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(AppDimens.paddingLarge),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grisBordure),
                        borderRadius: BorderRadius.circular(
                          AppDimens.borderRadiusMedium,
                        ),
                      ),
                      child: const Text(
                        'Aucun exercice dans cette séance',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ...seance.exercices.map((exercice) {
                      return ExerciceListeWidget(exercice: exercice);
                    }).toList(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Bouton Retour fixe
          Container(
            padding: const EdgeInsets.all(AppDimens.paddingLarge),
            decoration: BoxDecoration(
              color: AppColors.blanc,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: AppDimens.buttonHeight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.rougeAcr,
                  foregroundColor: AppColors.blanc,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimens.borderRadiusXLarge,
                    ),
                  ),
                  elevation: 8,
                ),
                child: const Text(
                  'Retour au menu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
