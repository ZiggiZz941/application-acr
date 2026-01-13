import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/dimens.dart';
import '../../constants/strings.dart';
import '../../models/allure_helper.dart';

class CalculSimpleScreen extends StatefulWidget {
  const CalculSimpleScreen({super.key});

  @override
  _CalculSimpleScreenState createState() => _CalculSimpleScreenState();
}

class _CalculSimpleScreenState extends State<CalculSimpleScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _vitesseController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  int _selectedAllure = 0;
  String _resultText = '--:--.--';
  bool _showResult = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.1, end: 1.2),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.2, end: 1.0),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _vitesseController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grisFond,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 30,
              left: AppDimens.paddingLarge,
              right: AppDimens.paddingLarge,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.rougeAcrDark, AppColors.rougeAcr],
              ),
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
            child: Column(
              children: [
                Text(
                  'Calcul de temps',
                  style: TextStyle(
                    color: AppColors.blanc,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Calcul basé sur la vitesse et l\'allure',
                  style: TextStyle(
                    color: AppColors.blanc.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Contenu
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.paddingLarge),
              child: Column(
                children: [
                  // Carte formulaire
                  Card(
                    elevation: AppDimens.cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.borderRadiusLarge,
                      ),
                    ),
                    color: AppColors.blanc,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.paddingXLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Vitesse
                          Text(
                            'Vitesse (km/h)',
                            style: TextStyle(
                              color: AppColors.rougeAcrDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _vitesseController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.blanc,
                              hintText: 'Ex: 16',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimens.borderRadiusMedium,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.rougeAcr,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.paddingMedium,
                                vertical: AppDimens.paddingMedium,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Distance
                          Text(
                            'Distance (mètres)',
                            style: TextStyle(
                              color: AppColors.rougeAcrDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _distanceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.blanc,
                              hintText: 'Ex: 1000',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimens.borderRadiusMedium,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.rougeAcr,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.paddingMedium,
                                vertical: AppDimens.paddingMedium,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Allure
                          Text(
                            'Allure',
                            style: TextStyle(
                              color: AppColors.rougeAcrDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.rougeAcr,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimens.borderRadiusMedium,
                              ),
                            ),
                            child: DropdownButtonFormField<int>(
                              value: _selectedAllure,
                              items: AppStrings.allures.asMap().entries.map((
                                entry,
                              ) {
                                return DropdownMenuItem<int>(
                                  value: entry.key,
                                  child: Text(
                                    entry.value,
                                    style: const TextStyle(
                                      color: AppColors.noir,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedAllure = value!;
                                });
                              },
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColors.blanc,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppDimens.paddingMedium,
                                  vertical: AppDimens.paddingMedium,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Bouton Calculer
                          SizedBox(
                            width: double.infinity,
                            height: AppDimens.buttonHeight,
                            child: ElevatedButton(
                              onPressed: _calculer,
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
                                'CALCULER',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Carte résultat
                  AnimatedOpacity(
                    opacity: _showResult ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _showResult ? null : 0,
                      child: Card(
                        elevation: AppDimens.cardElevation,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.borderRadiusLarge,
                          ),
                        ),
                        color: AppColors.blanc,
                        child: Padding(
                          padding: const EdgeInsets.all(
                            AppDimens.paddingXLarge,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RÉSULTAT',
                                style: TextStyle(
                                  color: AppColors.rougeAcrDark,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: Container(
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.rougeAcr,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.borderRadiusMedium,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _resultText,
                                      style: const TextStyle(
                                        color: AppColors.rougeAcr,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _calculer() {
    // Valider les entrées
    if (_vitesseController.text.isEmpty ||
        _distanceController.text.isEmpty ||
        _selectedAllure == 0) {
      _showError(AppStrings.fillAllFields);
      return;
    }

    try {
      double vitesseKmh = double.parse(
        _vitesseController.text.replaceAll(',', '.'),
      );
      double distance = double.parse(
        _distanceController.text.replaceAll(',', '.'),
      );

      // Récupérer la tranche d'allure
      AllureRange? allureRange = AllureHelper.getAllureRange(_selectedAllure);
      if (allureRange == null) {
        _showError(AppStrings.invalidAllure);
        return;
      }

      // Calcul du temps de base (100%)
      double vitesseMs = vitesseKmh / 3.6;
      double tempsBase100 = distance / vitesseMs;

      // Calcul des temps min et max selon la tranche
      double tempsMax = tempsBase100 / (allureRange.minPourcentage / 100.0);
      double tempsMin = tempsBase100 / (allureRange.maxPourcentage / 100.0);

      // Formater les résultats AVEC CENTIÈMES
      String tempsMinFormatted = _formatTimeAvecCentiemes(tempsMin);
      String tempsMaxFormatted = _formatTimeAvecCentiemes(tempsMax);

      // Préparer le texte du résultat
      String resultText;
      if (allureRange.minPourcentage == allureRange.maxPourcentage) {
        resultText = 'Temps : $tempsMinFormatted';
      } else {
        resultText = 'Zone : $tempsMinFormatted à $tempsMaxFormatted';
      }

      // Mettre à jour l'état avec animation
      setState(() {
        _resultText = resultText;
        if (!_showResult) {
          _showResult = true;
        }
      });

      // Lancer l'animation
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      _showError('Valeurs numériques invalides');
    }
  }

  String _formatTimeAvecCentiemes(double seconds) {
    int minutes = (seconds ~/ 60).toInt();
    double secondesDecimal = seconds % 60;

    if (secondesDecimal >= 60) {
      minutes += (secondesDecimal ~/ 60).toInt();
      secondesDecimal = secondesDecimal % 60;
    }

    if (minutes > 0) {
      return '${minutes}:${secondesDecimal.toStringAsFixed(2).padLeft(5, '0')}';
    } else {
      return '${secondesDecimal.toStringAsFixed(2)} sec';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
