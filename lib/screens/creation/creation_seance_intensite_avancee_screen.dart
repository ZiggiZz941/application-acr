import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/dimens.dart';
import '../../models/seance.dart';
import '../../models/exercice.dart';
import '../../services/data_manager.dart';
import '../../widgets/exercice_intensite_widget.dart';
import '../seance/visualisation_seance_screen.dart';

class CreationSeanceIntensiteAvanceeScreen extends StatefulWidget {
  const CreationSeanceIntensiteAvanceeScreen({super.key});

  @override
  _CreationSeanceIntensiteAvanceeScreenState createState() =>
      _CreationSeanceIntensiteAvanceeScreenState();
}

class _CreationSeanceIntensiteAvanceeScreenState
    extends State<CreationSeanceIntensiteAvanceeScreen> {
  final TextEditingController _nomSeanceController = TextEditingController();
  final List<Exercice> _listeExercices = [];
  int _exerciceCounter = 0;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void dispose() {
    _nomSeanceController.dispose();
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
                  'Version avancée - Multiple exercices',
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
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingMedium),
                    child: SingleChildScrollView(
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
                              padding: const EdgeInsets.all(
                                AppDimens.paddingLarge,
                              ),
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
                                      hintText: 'Ex: Séance intensité avancée',
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

                          // Titre exercices
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingSmall,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Exercices',
                                  style: TextStyle(
                                    color: AppColors.rougeAcrDark,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${_listeExercices.length} exercice(s)',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Liste des exercices
                          AnimatedList(
                            key: _listKey,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            initialItemCount: _listeExercices.length,
                            itemBuilder: (context, index, animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: ExerciceIntensiteWidget(
                                  key: ValueKey(_listeExercices[index].id),
                                  exercice: _listeExercices[index],
                                  onCalculer: (exercice) {
                                    setState(() {
                                      _updateExerciceInList(exercice);
                                    });
                                  },
                                  onSupprimer: () {
                                    _supprimerExercice(index);
                                  },
                                ),
                              );
                            },
                          ),

                          // Bouton Ajouter
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.paddingMedium,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: AppDimens.buttonHeight,
                              child: ElevatedButton.icon(
                                onPressed: _ajouterExercice,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.rougeAcr,
                                  foregroundColor: AppColors.blanc,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.borderRadiusXLarge,
                                    ),
                                  ),
                                  elevation: 6,
                                ),
                                icon: const Icon(Icons.add, size: 24),
                                label: const Text(
                                  'AJOUTER UN EXERCICE',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bouton Sauvegarder fixe
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
                      onPressed: _sauvegarderSeance,
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
                        'SAUVEGARDER LA SÉANCE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _ajouterExercice() {
    Exercice nouvelExercice = Exercice(
      id: _exerciceCounter++,
      nom: '',
      distance: 0,
      nbSeries: 1,
      nbRepetitions: 1,
      vma: 0,
      allure: 6,
      reposRepetitionsSec: 45,
      reposSeriesSec: 120,
    );

    setState(() {
      _listeExercices.add(nouvelExercice);
    });

    _listKey.currentState?.insertItem(_listeExercices.length - 1);
  }

  void _supprimerExercice(int index) {
    if (index >= 0 && index < _listeExercices.length) {
      Exercice exerciceASupprimer = _listeExercices[index];

      _listKey.currentState?.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: ExerciceIntensiteWidget(
            exercice: exerciceASupprimer,
            onCalculer: (_) {},
            onSupprimer: () {},
          ),
        ),
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _listeExercices.removeAt(index);
        });
      });
    }
  }

  void _updateExerciceInList(Exercice exercice) {
    int index = _listeExercices.indexWhere((e) => e.id == exercice.id);
    if (index != -1) {
      setState(() {
        _listeExercices[index] = exercice;
      });
    }
  }

  Future<void> _sauvegarderSeance() async {
    if (_listeExercices.isEmpty) {
      _showError('Ajoutez au moins un exercice');
      return;
    }

    String nomSeance = _nomSeanceController.text.trim();
    if (nomSeance.isEmpty) {
      final now = DateTime.now();
      nomSeance = 'Séance intensité ${now.day}/${now.month}';
    }

    Seance seance = Seance(nom: nomSeance);
    for (Exercice exercice in _listeExercices) {
      if (exercice.distance <= 0 || exercice.nbSeries <= 0) {
        _showError('Veuillez compléter tous les exercices');
        return;
      }
      seance.ajouterExercice(exercice);
    }

    DataManager dataManager = DataManager();
    bool saved = await dataManager.saveSeance(seance);

    if (saved) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Séance sauvegardée !'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisualisationSeanceScreen(seance: seance),
          ),
        );
      }
    } else {
      _showError('Erreur lors de la sauvegarde');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
