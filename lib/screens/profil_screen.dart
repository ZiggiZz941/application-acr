import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_manager.dart';
import '../constants/colors.dart';
import '../constants/dimens.dart';
import 'main_menu_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Charger les données utilisateur
    _loadUserData();
  }

  void _loadUserData() {
    DataManager dataManager = Provider.of<DataManager>(context, listen: false);
    _nomController.text = dataManager.getUserNom();
    _prenomController.text = dataManager.getUserPrenom();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataManager dataManager = Provider.of<DataManager>(context);
    String nom = dataManager.getUserNom();
    String prenom = dataManager.getUserPrenom();

    return Scaffold(
      backgroundColor: AppColors.rougeAcr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingXLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // En-tête avec logo
                Column(
                  children: [
                    Container(
                      width: 320,
                      height: 200,
                      margin: const EdgeInsets.only(bottom: 20),
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

                    Text(
                      'Mon Profil',
                      style: TextStyle(
                        color: AppColors.blanc,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      _getCurrentInfoText(prenom, nom),
                      style: TextStyle(
                        color: AppColors.blanc.withOpacity(0.8),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Carte formulaire
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimens.borderRadiusLarge,
                        ),
                      ),
                      color: AppColors.blanc,
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingXLarge),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Titre
                              Text(
                                'Modifier mes informations',
                                style: TextStyle(
                                  color: AppColors.noir,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Champ Nom
                              Text(
                                'Nom *',
                                style: TextStyle(
                                  color: AppColors.noir,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 5),

                              TextFormField(
                                controller: _nomController,
                                style: const TextStyle(
                                  color: AppColors.noir,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.grisChamp,
                                  hintText: 'Votre nom',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.borderRadiusMedium,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: AppDimens.paddingMedium,
                                    vertical: AppDimens.paddingMedium,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Le nom est obligatoire';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 15),

                              // Champ Prénom
                              Text(
                                'Prénom',
                                style: TextStyle(
                                  color: AppColors.noir,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 5),

                              TextFormField(
                                controller: _prenomController,
                                style: const TextStyle(
                                  color: AppColors.noir,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.grisChamp,
                                  hintText: 'Votre prénom (facultatif)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.borderRadiusMedium,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: AppDimens.paddingMedium,
                                    vertical: AppDimens.paddingMedium,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              // Note
                              Text(
                                '* Champ obligatoire',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Boutons
                Column(
                  children: [
                    // Bouton Enregistrer
                    SizedBox(
                      width: 280,
                      height: AppDimens.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String nom = _nomController.text.trim();
                            String prenom = _prenomController.text.trim();

                            await dataManager.saveUser(nom, prenom);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Profil mis à jour !'),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainMenuScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blanc,
                          foregroundColor: AppColors.rougeAcr,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.borderRadiusXLarge,
                            ),
                          ),
                          elevation: 8,
                        ),
                        child: const Text(
                          'Enregistrer les modifications',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Bouton Retour
                    SizedBox(
                      width: 200,
                      height: 45,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.blanc,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.borderRadiusXLarge,
                            ),
                          ),
                          side: BorderSide(color: AppColors.blanc, width: 2),
                        ),
                        child: const Text(
                          'Retour',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCurrentInfoText(String prenom, String nom) {
    if (prenom.isNotEmpty && nom.isNotEmpty) {
      return 'Profil actuel : $prenom $nom';
    } else if (nom.isNotEmpty) {
      return 'Profil actuel : $nom';
    } else {
      return 'Aucun profil enregistré';
    }
  }
}
