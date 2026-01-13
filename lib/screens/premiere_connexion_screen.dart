import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_manager.dart';
import '../constants/colors.dart';
import '../constants/dimens.dart';
import 'main_menu_screen.dart';

class PremiereConnexionScreen extends StatefulWidget {
  const PremiereConnexionScreen({super.key});

  @override
  _PremiereConnexionScreenState createState() =>
      _PremiereConnexionScreenState();
}

class _PremiereConnexionScreenState extends State<PremiereConnexionScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DataManager dataManager = Provider.of<DataManager>(context);

    return Scaffold(
      backgroundColor: AppColors.rougeAcr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingXLarge),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Logo ACR
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.blanc,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo_acr2.jpg',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Titre
                  Text(
                    'Bienvenue !',
                    style: TextStyle(
                      color: AppColors.blanc,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Entrez vos informations',
                    style: TextStyle(
                      color: AppColors.blanc.withOpacity(0.9),
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Champ Nom
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nom :',
                      style: TextStyle(color: AppColors.blanc, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _nomController,
                    style: const TextStyle(color: AppColors.noir, fontSize: 16),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.blanc,
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

                  const SizedBox(height: 20),

                  // Champ Prénom
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Prénom :',
                      style: TextStyle(color: AppColors.blanc, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _prenomController,
                    style: const TextStyle(color: AppColors.noir, fontSize: 16),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.blanc,
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

                  const SizedBox(height: 40),

                  // Bouton Continuer
                  SizedBox(
                    width: 250,
                    height: AppDimens.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String nom = _nomController.text.trim();
                          String prenom = _prenomController.text.trim();

                          await dataManager.saveUser(nom, prenom);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainMenuScreen(),
                            ),
                          );
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
                        'Continuer',
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
        ),
      ),
    );
  }
}
