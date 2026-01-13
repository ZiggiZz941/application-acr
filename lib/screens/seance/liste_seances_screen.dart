import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/dimens.dart';
import '../creation/creation_seance_screen.dart';
import '../main_menu_screen.dart';

class ListeSeancesScreen extends StatelessWidget {
  const ListeSeancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blanc,
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 150,
              height: 150,
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: AppColors.rougeAcr,
                borderRadius: BorderRadius.circular(75),
              ),
              child: const Icon(
                Icons.directions_run,
                size: 80,
                color: AppColors.blanc,
              ),
            ),

            // Titre
            Text(
              'Mes Séances',
              style: TextStyle(
                color: AppColors.rougeAcrDark,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // Message
            Text(
              'Consultez vos séances sauvegardées',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            // Bouton Nouvelle Séance
            SizedBox(
              width: double.infinity,
              height: AppDimens.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreationSeanceScreen(),
                    ),
                  );
                },
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
                  'Créer une nouvelle séance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bouton Retour
            SizedBox(
              width: double.infinity,
              height: AppDimens.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainMenuScreen(),
                    ),
                    (route) => false,
                  );
                },
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
