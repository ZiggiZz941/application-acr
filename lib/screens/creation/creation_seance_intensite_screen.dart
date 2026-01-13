import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/dimens.dart';
import '../../models/exercice.dart';
import '../../models/seance.dart';
import '../../services/data_manager.dart';
import '../seance/visualisation_seance_screen.dart';

class CreationSeanceIntensiteScreen extends StatefulWidget {
  const CreationSeanceIntensiteScreen({super.key});

  @override
  _CreationSeanceIntensiteScreenState createState() =>
      _CreationSeanceIntensiteScreenState();
}

class _CreationSeanceIntensiteScreenState
    extends State<CreationSeanceIntensiteScreen> {
  final TextEditingController _nomSeanceController = TextEditingController();
  final TextEditingController _tempsController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _intensiteController = TextEditingController();
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();
  final TextEditingController _reposRepetitionsController =
      TextEditingController();
  final TextEditingController _reposSeriesController = TextEditingController();

  double _tempsCalcule = 0;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    // Valeurs par défaut
    _seriesController.text = '3';
    _repetitionsController.text = '1';
    _reposRepetitionsController.text = '0:45';
    _reposSeriesController.text = '2:00';
    _intensiteController.text = '80.0';
  }

  @override
  void dispose() {
    _nomSeanceController.dispose();
    _tempsController.dispose();
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
    return Scaffold(
      backgroundColor: AppColors.grisFond,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
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
                  'Création par intensité',
                  style: TextStyle(
                    color: AppColors.blanc,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version simplifiée',
                  style: TextStyle(
                    color: AppColors.blanc.withOpacity(0.9),
                    fontSize: 14,
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
                  // Carte nom de séance
                  Card(
                    elevation: AppDimens.cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.borderRadiusLarge,
                      ),
                    ),
                    color: AppColors.blanc,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.paddingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nom de la séance',
                            style: TextStyle(
                              color: AppColors.rougeAcrDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _nomSeanceController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.blanc,
                              hintText: 'Ex: Séance intensité simple',
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
                  ),

                  const SizedBox(height: 20),

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
                      padding: const EdgeInsets.all(AppDimens.paddingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DONNÉES DE BASE',
                            style: TextStyle(
                              color: AppColors.rougeAcrDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Temps
                          Text(
                            'Temps de référence',
                            style: TextStyle(
                              color: AppColors.rougeAcrDark,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _tempsController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.blanc,
                              hintText: 'Ex: 12.50 ou 1:12.50',
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

                          // Distance et Intensité
                          Row(
                            children: [
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal:
                                                  AppDimens.paddingMedium,
                                              vertical: AppDimens.paddingMedium,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

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
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal:
                                                  AppDimens.paddingMedium,
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

                          Text(
                            'STRUCTURE DE LA SÉANCE',
                            style: TextStyle(
                              color: AppColors.rougeAcrDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Séries et Répétitions
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal:
                                                  AppDimens.paddingMedium,
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal:
                                                  AppDimens.paddingMedium,
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

                          // Repos
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal:
                                                  AppDimens.paddingMedium,
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal:
                                                  AppDimens.paddingMedium,
                                              vertical: AppDimens.paddingMedium,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // Bouton Calculer
                          SizedBox(
                            width: double.infinity,
                            height: AppDimens.buttonHeight,
                            child: ElevatedButton(
                              onPressed: _calculerEtAfficher,
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
                                'CALCULER LA SÉANCE',
                                style: TextStyle(
                                  fontSize: 16,
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

                  // Section résultats
                  if (_showResult) ...[
                    Text(
                      'RÉSULTATS',
                      style: TextStyle(
                        color: AppColors.rougeAcrDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Carte résultat
                    Card(
                      elevation: AppDimens.cardElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimens.borderRadiusLarge,
                        ),
                      ),
                      color: AppColors.rougeAcr,
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Résumé de la séance',
                              style: TextStyle(
                                color: AppColors.blanc,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getResultText(),
                              style: const TextStyle(
                                color: AppColors.blanc,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Détail série par série
                    Card(
                      elevation: AppDimens.cardElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimens.borderRadiusLarge,
                        ),
                      ),
                      color: AppColors.blanc,
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Détail série par série',
                              style: TextStyle(
                                color: AppColors.rougeAcrDark,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getDetailText(),
                              style: const TextStyle(
                                color: AppColors.noir,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],

                  // Bouton Sauvegarder
                  SizedBox(
                    width: double.infinity,
                    height: AppDimens.buttonHeight,
                    child: ElevatedButton(
                      onPressed: _showResult ? _sauvegarderSeance : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.rougeAcr,
                        foregroundColor: AppColors.blanc,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.borderRadiusXLarge,
                          ),
                        ),
                        elevation: 12,
                      ),
                      child: const Text(
                        'SAUVEGARDER CETTE SÉANCE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  void _calculerEtAfficher() {
    String tempsStr = _tempsController.text.trim();
    String distanceStr = _distanceController.text.trim();
    String intensiteStr = _intensiteController.text.trim();
    String seriesStr = _seriesController.text.trim();
    String repetitionsStr = _repetitionsController.text.trim();

    // Validation
    if (tempsStr.isEmpty ||
        distanceStr.isEmpty ||
        intensiteStr.isEmpty ||
        seriesStr.isEmpty ||
        repetitionsStr.isEmpty) {
      _showError('Veuillez remplir tous les champs obligatoires');
      return;
    }

    double? distance = _parseDouble(distanceStr);
    double? intensite = _parseDouble(intensiteStr);
    int? series = int.tryParse(seriesStr);
    int? repetitions = int.tryParse(repetitionsStr);

    if (distance == null ||
        intensite == null ||
        series == null ||
        repetitions == null) {
      _showError('Valeurs numériques invalides');
      return;
    }

    if (intensite <= 0 || intensite > 100) {
      _showError('L\'intensité doit être entre 1 et 100%');
      return;
    }

    // Convertir le temps
    double tempsSecondes = _convertirTempsEnSecondes(tempsStr);
    if (tempsSecondes < 0) {
      _showError('Format de temps invalide');
      return;
    }

    // Calcul du temps à l'intensité
    _tempsCalcule = (tempsSecondes * 100.0) / intensite;

    setState(() {
      _showResult = true;
    });
  }

  String _getResultText() {
    double distance = _parseDouble(_distanceController.text) ?? 0;
    int series = int.tryParse(_seriesController.text) ?? 0;
    int repetitions = int.tryParse(_repetitionsController.text) ?? 0;
    String reposRepFormate = _reposRepetitionsController.text;
    String reposSerFormate = _reposSeriesController.text;
    String tempsFormate = _formatTempsAvecCentiemes(_tempsCalcule);

    return '$series séries de $repetitions x ${distance.toInt()}m à $tempsFormate\n'
        'Repos entre répétitions: $reposRepFormate\n'
        'Repos entre séries: $reposSerFormate';
  }

  String _getDetailText() {
    double distance = _parseDouble(_distanceController.text) ?? 0;
    int series = int.tryParse(_seriesController.text) ?? 0;
    int repetitions = int.tryParse(_repetitionsController.text) ?? 0;
    String reposRepFormate = _reposRepetitionsController.text;
    String reposSerFormate = _reposSeriesController.text;
    String tempsFormate = _formatTempsAvecCentiemes(_tempsCalcule);

    StringBuffer detail = StringBuffer();
    double tempsTotalSerie =
        (_tempsCalcule * repetitions) +
        (Exercice.parseTempsEnSecondes(reposRepFormate) * (repetitions - 1));

    for (int s = 1; s <= series; s++) {
      detail.write('Série $s:\n');

      for (int r = 1; r <= repetitions; r++) {
        detail.write(
          '  Répétition $r: ${distance.toInt()}m en $tempsFormate\n',
        );

        if (r < repetitions) {
          detail.write('  Repos: $reposRepFormate\n');
        }
      }

      if (s < series) {
        detail.write('Repos entre séries: $reposSerFormate\n\n');
      }
    }

    // Temps total estimé
    double tempsTotal =
        (tempsTotalSerie * series) +
        (Exercice.parseTempsEnSecondes(reposSerFormate) * (series - 1));
    detail.write(
      '\nTemps total estimé: ${_formatTempsAvecCentiemes(tempsTotal)}',
    );

    return detail.toString();
  }

  Future<void> _sauvegarderSeance() async {
    if (_tempsCalcule == 0) {
      _showError('Calculez d\'abord la séance');
      return;
    }

    // Récupérer toutes les valeurs
    double? distance = _parseDouble(_distanceController.text);
    int? series = int.tryParse(_seriesController.text);
    int? repetitions = int.tryParse(_repetitionsController.text);
    String intensiteStr = _intensiteController.text;
    String reposRepStr = _reposRepetitionsController.text;
    String reposSerStr = _reposSeriesController.text;

    if (distance == null || series == null || repetitions == null) {
      _showError('Valeurs invalides');
      return;
    }

    int reposRepSec = Exercice.parseTempsEnSecondes(reposRepStr);
    int reposSerSec = Exercice.parseTempsEnSecondes(reposSerStr);

    if (series == 1) {
      reposSerSec = 0;
    }

    // Créer un nom pour la séance
    String nomSeance = _nomSeanceController.text.trim();
    if (nomSeance.isEmpty) {
      nomSeance =
          'Séance ${intensiteStr}% - ${series}x${repetitions}x${distance.toInt()}m';
    }

    // Calculer la VMA pour obtenir le bon temps
    double vmaCalculee = _calculerVmaPourTemps(distance, _tempsCalcule);

    Exercice exercice = Exercice(
      nom: 'Exercice intensité ${intensiteStr}%',
      distance: distance,
      nbSeries: series,
      nbRepetitions: repetitions,
      vma: vmaCalculee,
      allure: 6, // VMA
      reposRepetitionsSec: reposRepSec,
      reposSeriesSec: reposSerSec,
    );

    // Créer la séance
    Seance seance = Seance(nom: nomSeance);
    seance.ajouterExercice(exercice);

    // Vérifier la limite
    DataManager dataManager = DataManager();
    bool limitReached = await dataManager.isLimitReached();

    if (limitReached) {
      bool continuer = await _showLimitWarning();
      if (!continuer) return;
    }

    // Sauvegarder
    bool saved = await dataManager.saveSeance(seance);

    if (saved) {
      _showSuccess('Séance sauvegardée !');

      // Naviguer vers la visualisation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisualisationSeanceScreen(seance: seance),
        ),
      );
    } else {
      _showError('Erreur lors de la sauvegarde');
    }
  }

  double _calculerVmaPourTemps(double distance, double tempsSecondes) {
    if (tempsSecondes <= 0) return 18.0;
    double vitesseMs = distance / tempsSecondes;
    return vitesseMs * 3.6;
  }

  double _convertirTempsEnSecondes(String tempsStr) {
    try {
      if (tempsStr.contains(":")) {
        List<String> parties = tempsStr.split(":");
        if (parties.length == 2) {
          double minutes = _parseDouble(parties[0]) ?? 0;
          double secondes = _parseDouble(parties[1]) ?? 0;
          if (minutes < 0 || secondes < 0 || secondes >= 60) {
            return -1;
          }
          return (minutes * 60) + secondes;
        }
      }
      double secondes = _parseDouble(tempsStr) ?? 0;
      if (secondes < 0) {
        return -1;
      }
      return secondes;
    } catch (e) {
      return -1;
    }
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

  double? _parseDouble(String value) {
    if (value.trim().isEmpty) return null;
    try {
      value = value.replaceAll(',', '.');
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }

  Future<bool> _showLimitWarning() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Limite atteinte'),
            content: const Text(
              'Vous avez déjà 25 séances sauvegardées.\n\n'
              'La création d\'une nouvelle séance supprimera automatiquement la plus ancienne.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Continuer'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}
