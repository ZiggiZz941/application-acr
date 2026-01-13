import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimens.dart';
import '../models/exercice.dart';

class ExerciceIntensiteWidget extends StatefulWidget {
  final Exercice exercice;
  final Function(Exercice) onCalculer;
  final VoidCallback onSupprimer;

  const ExerciceIntensiteWidget({
    super.key,
    required this.exercice,
    required this.onCalculer,
    required this.onSupprimer,
  });

  @override
  _ExerciceIntensiteWidgetState createState() =>
      _ExerciceIntensiteWidgetState();
}

class _ExerciceIntensiteWidgetState extends State<ExerciceIntensiteWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _tempsRefController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _intensiteController = TextEditingController();
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();
  final TextEditingController _reposRepetitionsController =
      TextEditingController();
  final TextEditingController _reposSeriesController = TextEditingController();
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

    // Initialiser avec des valeurs par défaut
    _nomController.text = widget.exercice.nom;
    _tempsRefController.text = '';
    _distanceController.text = widget.exercice.distance > 0
        ? widget.exercice.distance.toInt().toString()
        : '100';
    _intensiteController.text = '80.0';
    _seriesController.text = widget.exercice.nbSeries > 0
        ? widget.exercice.nbSeries.toString()
        : '3';
    _repetitionsController.text = widget.exercice.nbRepetitions > 0
        ? widget.exercice.nbRepetitions.toString()
        : '1';
    _reposRepetitionsController.text = widget.exercice.reposRepetitionsFormate;
    _reposSeriesController.text = widget.exercice.reposSeriesFormate;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nomController.dispose();
    _tempsRefController.dispose();
    _distanceController.dispose();
    _intensiteController.dispose();
    _seriesController.dispose();
    _repetitionsController.dispose();
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
                  'Exercice intensité',
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
                hintText: 'Ex: 1000m à 80%',
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

            // Deux colonnes Temps/Distance
            Row(
              children: [
                // Temps référence
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temps référence',
                        style: TextStyle(
                          color: AppColors.rougeAcrDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _tempsRefController,
                        onChanged: (_) => _updateExercice(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.blanc,
                          hintText: 'Ex: 12.50',
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

                // Distance
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distance (m)',
                        style: TextStyle(
                          color: AppColors.rougeAcrDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _distanceController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _updateExercice(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.blanc,
                          hintText: 'Ex: 100',
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

            // Deux colonnes Intensité/Structure
            Row(
              children: [
                // Intensité
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Intensité (%)',
                        style: TextStyle(
                          color: AppColors.rougeAcrDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _intensiteController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => _updateExercice(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.blanc,
                          hintText: 'Ex: 80.0',
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

                // Deux colonnes internes pour Séries/Répétitions
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre
                      Text(
                        'Structure',
                        style: TextStyle(
                          color: AppColors.rougeAcrDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Deux sous-colonnes
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
                                    fontSize: 14,
                                  ),
                                ),
                                TextField(
                                  controller: _seriesController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => _updateExercice(),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.blanc,
                                    hintText: '3',
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
                                      horizontal: AppDimens.paddingSmall,
                                      vertical: AppDimens.paddingSmall,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 4),

                          // Répétitions
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Répétitions',
                                  style: TextStyle(
                                    color: AppColors.rougeAcrDark,
                                    fontSize: 14,
                                  ),
                                ),
                                TextField(
                                  controller: _repetitionsController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => _updateExercice(),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.blanc,
                                    hintText: '1',
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
                                      horizontal: AppDimens.paddingSmall,
                                      vertical: AppDimens.paddingSmall,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
      String tempsRefStr = _tempsRefController.text.trim();
      String distanceStr = _distanceController.text.trim();
      String intensiteStr = _intensiteController.text.trim();
      String seriesStr = _seriesController.text.trim();
      String repetitionsStr = _repetitionsController.text.trim();
      String reposRepStr = _reposRepetitionsController.text.trim();
      String reposSerStr = _reposSeriesController.text.trim();

      // Validation
      if (tempsRefStr.isEmpty ||
          distanceStr.isEmpty ||
          intensiteStr.isEmpty ||
          seriesStr.isEmpty ||
          repetitionsStr.isEmpty) {
        return;
      }

      // Convertir le temps
      double tempsSecondes = _convertirTempsEnSecondes(tempsRefStr);
      if (tempsSecondes < 0) {
        return;
      }

      double distance = double.parse(distanceStr.replaceAll(',', '.'));
      double intensite = double.parse(intensiteStr.replaceAll(',', '.'));
      int series = int.parse(seriesStr);
      int repetitions = int.parse(repetitionsStr);
      int reposRepSec = Exercice.parseTempsEnSecondes(reposRepStr);
      int reposSerSec = Exercice.parseTempsEnSecondes(reposSerStr);

      // Validations
      if (distance <= 0 || series <= 0 || intensite <= 0 || intensite > 100) {
        return;
      }

      if (repetitions <= 0) repetitions = 1;
      if (reposRepSec < 0) reposRepSec = 0;
      if (reposSerSec < 0) reposSerSec = 0;

      // Si une seule série, ignorer le repos entre séries
      if (series == 1) {
        reposSerSec = 0;
      }

      // Calcul du temps à l'intensité
      double tempsCalcule = (tempsSecondes * 100.0) / intensite;

      // Calculer la VMA nécessaire pour obtenir ce temps
      double vmaCalculee = _calculerVmaPourTemps(distance, tempsCalcule);

      // Créer le nom si vide
      if (nom.isEmpty) {
        nom = '${distance.toInt()}m à ${intensite.toInt()}%';
      }

      // Mettre à jour l'exercice
      widget.exercice.nom = nom;
      widget.exercice.distance = distance;
      widget.exercice.nbSeries = series;
      widget.exercice.nbRepetitions = repetitions;
      widget.exercice.vma = vmaCalculee;
      widget.exercice.allure = 6; // VMA
      widget.exercice.reposRepetitionsSec = reposRepSec;
      widget.exercice.reposSeriesSec = reposSerSec;

      // Recalculer les temps
      widget.exercice.calculerTemps();

      // Formater le résultat
      String tempsFormate = _formatTempsAvecCentiemes(widget.exercice.tempsMin);
      String reposRepFormate = Exercice.formatTempsEnMinutes(reposRepSec);
      String reposSerFormate = Exercice.formatTempsEnMinutes(reposSerSec);

      setState(() {
        _resultText =
            '$series séries de $repetitions x ${distance.toInt()}m à $tempsFormate\n'
            'Repos répétitions: $reposRepFormate\n'
            'Repos séries: $reposSerFormate';
        _showResult = true;
      });

      // Notifier le parent
      widget.onCalculer(widget.exercice);
    } catch (e) {
      // Ignorer les erreurs de parsing pendant la saisie
    }
  }

  double _convertirTempsEnSecondes(String tempsStr) {
    try {
      if (tempsStr.contains(":")) {
        List<String> parties = tempsStr.split(":");
        if (parties.length == 2) {
          double minutes = double.parse(parties[0].replaceAll(',', '.'));
          double secondes = double.parse(parties[1].replaceAll(',', '.'));
          if (minutes < 0 || secondes < 0 || secondes >= 60) {
            return -1;
          }
          return (minutes * 60) + secondes;
        }
      }
      double secondes = double.parse(tempsStr.replaceAll(',', '.'));
      if (secondes < 0) {
        return -1;
      }
      return secondes;
    } catch (e) {
      return -1;
    }
  }

  double _calculerVmaPourTemps(double distance, double tempsSecondes) {
    if (tempsSecondes <= 0) return 18.0;
    double vitesseMs = distance / tempsSecondes;
    return vitesseMs * 3.6;
  }

  String _formatTempsAvecCentiemes(double seconds) {
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
}
