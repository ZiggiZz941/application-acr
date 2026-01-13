import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/dimens.dart';
import '../../models/seance.dart';
import '../../services/data_manager.dart';
import '../../widgets/seance_item_widget.dart';
import '../creation/creation_seance_screen.dart';
import 'visualisation_seance_screen.dart';

class HistoriqueSeancesScreen extends StatefulWidget {
  const HistoriqueSeancesScreen({super.key});

  @override
  _HistoriqueSeancesScreenState createState() =>
      _HistoriqueSeancesScreenState();
}

class _HistoriqueSeancesScreenState extends State<HistoriqueSeancesScreen> {
  List<Seance> _seances = [];
  bool _isLoading = true;
  final DataManager dataManager = DataManager(); // Création directe

  @override
  void initState() {
    super.initState();
    _chargerSeances();
  }

  Future<void> _chargerSeances() async {
    List<Seance> loadedSeances = await dataManager.loadAllSeances();

    setState(() {
      _seances = loadedSeances;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blanc,
      body: Column(
        children: [
          // Titre
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
              'Mes Séances Sauvegardées',
              style: TextStyle(
                color: AppColors.blanc,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Contenu
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.rougeAcr),
                  )
                : _seances.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 80,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Aucune séance sauvegardée',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _chargerSeances,
                    color: AppColors.rougeAcr,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppDimens.paddingLarge),
                      itemCount: _seances.length,
                      itemBuilder: (context, index) {
                        return SeanceItemWidget(
                          seance: _seances[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VisualisationSeanceScreen(
                                  seance: _seances[index],
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            _showDeleteDialog(_seances[index]);
                          },
                        );
                      },
                    ),
                  ),
          ),

          // Boutons fixes en bas
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
            child: Column(
              children: [
                // Bouton Nouvelle Séance
                SizedBox(
                  width: double.infinity,
                  height: AppDimens.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () async {
                      DataManager dataManager = DataManager();
                      bool limitReached = await dataManager.isLimitReached();

                      if (limitReached && mounted) {
                        bool continuer = await _showLimitWarning();
                        if (continuer) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreationSeanceScreen(),
                            ),
                          );
                        }
                      } else if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreationSeanceScreen(),
                          ),
                        );
                      }
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Bouton Retour
                SizedBox(
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
                      style: TextStyle(fontSize: 16),
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

  Future<void> _showDeleteDialog(Seance seance) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la séance'),
        content: Text(
          'Voulez-vous vraiment supprimer la séance "${seance.nom}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      DataManager dataManager = DataManager();
      bool deleted = await dataManager.deleteSeance(seance.id);

      if (deleted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Séance supprimée'),
            backgroundColor: Colors.green,
          ),
        );

        // Recharger la liste
        await _chargerSeances();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la suppression'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
