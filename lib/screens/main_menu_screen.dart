import 'package:acr_flutter/screens/premiere_connexion_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_manager.dart';
import '../constants/colors.dart';
import '../constants/dimens.dart';
import './calcul/calcul_simple_screen.dart';
import './calcul/calcul_intensite_screen.dart';
import './calcul/chronometre_screen.dart';
import './creation/creation_seance_screen.dart';
import './creation/creation_seance_intensite_avancee_screen.dart';
import './seance/historique_seances_screen.dart';
import './profil_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _clickCount = 0;
  DateTime _lastClickTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context);
    String nom = dataManager.getUserNom();
    String prenom = dataManager.getUserPrenom();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.rougeAcrDark,
              AppColors.rougeAcr,
              AppColors.rougeAcrLight,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header avec logo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 30,
                left: AppDimens.paddingLarge,
                right: AppDimens.paddingLarge,
              ),
              decoration: BoxDecoration(
                color: AppColors.rougeAcrDark,
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
                  // Logo ACR
                  Container(
                    width: 320,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.blanc,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo_acr.png',
                      width: 250,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Texte de bienvenue
                  GestureDetector(
                    onTap: () {
                      DateTime now = DateTime.now();
                      if (now.difference(_lastClickTime).inSeconds > 1) {
                        _clickCount = 0;
                      }

                      _clickCount++;
                      _lastClickTime = now;

                      if (_clickCount >= 3) {
                        _clickCount = 0;
                        _showDebugMenu(context, dataManager);
                      }
                    },
                    child: Text(
                      _getWelcomeText(prenom, nom),
                      style: const TextStyle(
                        color: AppColors.blanc,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenu principal avec défilement
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.paddingLarge),
                child: Column(
                  children: [
                    // Section Calculateurs
                    _buildSectionCard(
                      title: 'Calculateurs',
                      children: [
                        _buildMenuButton(
                          text: 'Calcul simple (allure)',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CalculSimpleScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildMenuButton(
                          text: 'Calcul par intensité (%)',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CalculIntensiteScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Section Séances
                    _buildSectionCard(
                      title: 'Séances',
                      children: [
                        _buildMenuButton(
                          text: 'Créer une séance',
                          onPressed: () async {
                            bool limitReached = await dataManager
                                .isLimitReached();
                            if (limitReached && context.mounted) {
                              _showLimitWarning(context, 'classique');
                            } else if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreationSeanceScreen(),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildMenuButton(
                          text: 'Créer séance par intensité',
                          onPressed: () async {
                            bool limitReached = await dataManager
                                .isLimitReached();
                            if (limitReached && context.mounted) {
                              _showIntensityLimitWarning(context);
                            } else if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreationSeanceIntensiteAvanceeScreen(),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder<int>(
                          future: dataManager.getSeancesCount(),
                          builder: (context, snapshot) {
                            int count = snapshot.data ?? 0;
                            return _buildMenuButton(
                              text: 'Mes séances ($count/25)',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HistoriqueSeancesScreen(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Section Autres options
                    _buildSectionCard(
                      title: 'Autres options',
                      children: [
                        _buildMenuButton(
                          text: 'Chronomètre',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChronometreScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildMenuButton(
                          text: 'Modifier mon profil',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Section Infos
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
                              'Club ACR Athlétisme',
                              style: TextStyle(
                                color: AppColors.rougeAcr,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Application d\'entraînement',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: AppDimens.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusLarge),
      ),
      color: AppColors.blanc,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.noir,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: AppDimens.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rougeAcr,
          foregroundColor: AppColors.blanc,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusLarge),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _getWelcomeText(String prenom, String nom) {
    if (prenom.isNotEmpty && nom.isNotEmpty) {
      return 'Bonjour $prenom $nom !';
    } else if (nom.isNotEmpty) {
      return 'Bonjour $nom !';
    } else {
      return 'Bonjour !';
    }
  }

  void _showDebugMenu(BuildContext context, DataManager dataManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Menu Debug'),
        content: const Text('Que voulez-vous faire ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetFirstLaunch(dataManager);
            },
            child: const Text('Reset 1ère connexion'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showJsonDebug(dataManager);
            },
            child: const Text('Voir JSON'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showLimitWarning(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limite atteinte'),
        content: const Text(
          'Vous avez déjà 25 séances sauvegardées.\n\n'
          'La création d\'une nouvelle séance supprimera automatiquement la plus ancienne.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (type == 'classique') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreationSeanceScreen(),
                  ),
                );
              }
            },
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showIntensityLimitWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limite atteinte'),
        content: const Text(
          'Vous avez déjà 25 séances sauvegardées.\n\n'
          'La création supprimera la plus ancienne.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CreationSeanceIntensiteAvanceeScreen(),
                ),
              );
            },
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetFirstLaunch(DataManager dataManager) async {
    // Réinitialisation manuelle
    await dataManager.saveUser('', '');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const PremiereConnexionScreen()),
      (route) => false,
    );
  }

  Future<void> _showJsonDebug(DataManager dataManager) async {
    String jsonContent = await dataManager.debugGetJsonContent();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('JSON Debug'),
        content: SingleChildScrollView(
          child: SelectableText(
            jsonContent,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
