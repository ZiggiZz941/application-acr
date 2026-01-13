import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimens.dart';
import '../constants/strings.dart';
import '../models/exercice.dart';

class ExerciceFormWidget extends StatefulWidget {
  final Exercice exercice;
  final Function(Exercice) onCalculer;
  final VoidCallback onSupprimer;

  const ExerciceFormWidget({
    super.key,
    required this.exercice,
    required this.onCalculer,
    required this.onSupprimer,
  });

  @override
  _ExerciceFormWidgetState createState() => _ExerciceFormWidgetState();
}

class _ExerciceFormWidgetState extends State<ExerciceFormWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();
  final TextEditingController _vmaController = TextEditingController();
  final TextEditingController _reposRepetitionsController =
      TextEditingController();
  final TextEditingController _reposSeriesController = TextEditingController();
  int _selectedAllure =
      2; // Allure 3 par défaut (index 2 dans allures_simplifie)
  bool _showResult = false;
  String _resultText = '';

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Initialiser les contrôleurs avec les valeurs de l'exercice
    _nomController.text = widget.exercice.nom;
    _distanceController.text = widget.exercice.distance > 0
        ? widget.exercice.distance.toInt().toString()
        : '';
    _seriesController.text = widget.exercice.nbSeries > 0
        ? widget.exercice.nbSeries.toString()
        : '1';
    _repetitionsController.text = widget.exercice.nbRepetitions > 0
        ? widget.exercice.nbRepetitions.toString()
        : '1';
    _vmaController.text = widget.exercice.vma > 0
        ? widget.exercice.vma.toStringAsFixed(1)
        : '';
    _reposRepetitionsController.text = widget.exercice.reposRepetitionsFormate;
    _reposSeriesController.text = widget.exercice.reposSeriesFormate;
    _selectedAllure = widget.exercice.allure - 1;

    // Si l'exercice a déjà des valeurs, calculer
    if (widget.exercice.distance > 0 && widget.exercice.vma > 0) {
      _updateExercice();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nomController.dispose();
    _distanceController.dispose();
    _seriesController.dispose();
    _repetitionsController.dispose();
    _vmaController.dispose();
    _reposRepetitionsController.dispose();
    _reposSeriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
      ),
      color: AppColors.blanc,
      margin: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec bouton supprimer
            Row(
              children: [
                Text(
                  'Exercice',
                  style: TextStyle(
                    color: AppColors.rougeAcrDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: widget.onSupprimer,
                  icon: const Icon(Icons.close, color: AppColors.rougeAcr),
                  iconSize: 24,
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Nom de l'exercice
            Text(
              'Nom (optionnel)',
              style: TextStyle(color: AppColors.rougeAcrDark, fontSize: 16),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _nomController,
              onChanged: (_) => _updateExercice(),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.blanc,
                hintText: 'Ex: 1000m endurance',
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

            const SizedBox(height: 15),

            // Distance
            Text(
              'Distance (m)',
              style: TextStyle(color: AppColors.rougeAcrDark, fontSize: 16),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              onChanged: (_) => _updateExercice(),
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

            const SizedBox(height: 15),

            // Deux colonnes Séries/Répétitions
            Row(
              children: [
                // Séries
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Séries',
                        style: TextStyle(
                          color: AppColors.rougeAcrDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _seriesController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _updateExercice(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.blanc,
                          hintText: 'Ex: 3',
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
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Répétitions
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Répétitions',
                        style: TextStyle(
                          color: AppColors.rougeAcrDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _repetitionsController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _updateExercice(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.blanc,
                          hintText: 'Ex: 4',
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
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // VMA
            Text(
              'VMA (km/h)',
              style: TextStyle(color: AppColors.rougeAcrDark, fontSize: 16),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _vmaController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _updateExercice(),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.blanc,
                hintText: 'Ex: 16.5',
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

            const SizedBox(height: 15),

            // Allure
            Text(
              'Allure',
              style: TextStyle(color: AppColors.rougeAcrDark, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.rougeAcr, width: 2),
                borderRadius: BorderRadius.circular(
                  AppDimens.borderRadiusMedium,
                ),
              ),
              child: DropdownButtonFormField<int>(
                value: _selectedAllure,
                items: AppStrings.alluresSimplifie.asMap().entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: AppColors.noir,
                        fontSize: 15,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAllure = value!;
                  });
                  _updateExercice();
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

            const SizedBox(height: 15),

            // Deux colonnes Repos
            Row(
              children: [
                // Repos répétitions
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Repos répétitions',
                        style: TextStyle(
                          color: AppColors.rougeAcrDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _reposRepetitionsController,
                        onChanged: (_) => _updateExercice(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.blanc,
                          hintText: 'Ex: 0:45',
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
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Repos séries
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Repos séries',
                        style: TextStyle(
                          color: AppColors.rougeAcrDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _reposSeriesController,
                        onChanged: (_) => _updateExercice(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.blanc,
                          hintText: 'Ex: 2:00',
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
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Bouton Prévisualiser
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _updateExercice();
                  _animationController.reset();
                  _animationController.forward();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blanc,
                  foregroundColor: AppColors.rougeAcrDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimens.borderRadiusXLarge,
                    ),
                    side: BorderSide(color: AppColors.rougeAcrDark, width: 2),
                  ),
                ),
                child: const Text(
                  'PRÉVISUALISER',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Zone résultat
            AnimatedOpacity(
              opacity: _showResult ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showResult ? null : 0,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.rougeAcr, width: 2),
                      borderRadius: BorderRadius.circular(
                        AppDimens.borderRadiusMedium,
                      ),
                    ),
                    child: Text(
                      _resultText,
                      style: TextStyle(
                        color: AppColors.rougeAcrDark,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateExercice() {
    try {
      // Parser les valeurs
      String nom = _nomController.text.trim();
      if (nom.isEmpty) {
        nom = 'Exercice ${_selectedAllure + 1}';
      }

      double distance = double.parse(
        _distanceController.text.replaceAll(',', '.'),
      );
      int series = int.parse(_seriesController.text);
      int repetitions = int.parse(_repetitionsController.text);
      double vma = double.parse(_vmaController.text.replaceAll(',', '.'));
      int reposRepSec = Exercice.parseTempsEnSecondes(
        _reposRepetitionsController.text,
      );
      int reposSerSec = Exercice.parseTempsEnSecondes(
        _reposSeriesController.text,
      );

      // Validations
      if (distance <= 0 || series <= 0 || vma <= 0) {
        return;
      }

      if (repetitions <= 0) repetitions = 1;
      if (reposRepSec < 0) reposRepSec = 0;
      if (reposSerSec < 0) reposSerSec = 0;

      // Si une seule série, ignorer le repos entre séries
      if (series == 1) {
        reposSerSec = 0;
      }

      int allure = _selectedAllure + 1;

      // Mettre à jour l'exercice
      widget.exercice.nom = nom;
      widget.exercice.distance = distance;
      widget.exercice.nbSeries = series;
      widget.exercice.nbRepetitions = repetitions;
      widget.exercice.vma = vma;
      widget.exercice.allure = allure;
      widget.exercice.reposRepetitionsSec = reposRepSec;
      widget.exercice.reposSeriesSec = reposSerSec;

      // Recalculer les temps
      widget.exercice.calculerTemps();

      // Mettre à jour le texte de résultat
      setState(() {
        _resultText = widget.exercice.getDescriptionDetaillee();
        _showResult = true;
      });

      // Notifier le parent
      widget.onCalculer(widget.exercice);
    } catch (e) {
      // Ignorer les erreurs de parsing pendant la saisie
    }
  }
}
