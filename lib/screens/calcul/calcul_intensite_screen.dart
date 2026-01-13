import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/dimens.dart';

class CalculIntensiteScreen extends StatefulWidget {
  const CalculIntensiteScreen({super.key});

  @override
  _CalculIntensiteScreenState createState() => _CalculIntensiteScreenState();
}

class _CalculIntensiteScreenState extends State<CalculIntensiteScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _tempsController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _intensiteController = TextEditingController();
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
            curve: Curves.bounceOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tempsController.dispose();
    _distanceController.dispose();
    _intensiteController.dispose();
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
                  'Calcul par intensité',
                  style: TextStyle(
                    color: AppColors.blanc,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Convertir un temps à une intensité donnée',
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
                          // Temps
                          Text(
                            'Temps de référence',
                            style: TextStyle(
                              color: AppColors.rougeAcrDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
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

                          const SizedBox(height: 20),

                          // Intensité
                          Text(
                            'Intensité (%)',
                            style: TextStyle(
                              color: AppColors.rougeAcrDark,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _intensiteController,
                            keyboardType: TextInputType.numberWithOptions(
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.paddingMedium,
                                vertical: AppDimens.paddingMedium,
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
    // Récupérer les valeurs
    String tempsStr = _tempsController.text.trim();
    String distanceStr = _distanceController.text.trim();
    String intensiteStr = _intensiteController.text.trim();

    // Validation
    if (tempsStr.isEmpty || distanceStr.isEmpty || intensiteStr.isEmpty) {
      _showError('Veuillez remplir tous les champs');
      return;
    }

    // Parser les valeurs
    double? distance = _parseDouble(distanceStr);
    double? intensite = _parseDouble(intensiteStr);

    if (distance == null || intensite == null) {
      _showError('Valeurs numériques invalides');
      return;
    }

    if (intensite <= 0 || intensite > 100) {
      _showError('L\'intensité doit être entre 1 et 100%');
      return;
    }

    // Convertir le temps (format mm:ss.xx ou ss.xx)
    double tempsSecondes = _convertirTempsEnSecondes(tempsStr);
    if (tempsSecondes < 0) {
      _showError('Format de temps invalide. Utilisez mm:ss.xx ou ss.xx');
      return;
    }

    // Calcul : Temps à l'intensité = (Temps * 100) / Intensité
    double tempsFinal = (tempsSecondes * 100.0) / intensite;

    // Formater le résultat
    String resultText = _formatResultAvecCentiemes(tempsFinal);

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
  }

  double _convertirTempsEnSecondes(String tempsStr) {
    try {
      // Si le temps contient ':' (format mm:ss.xx)
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
      // Sinon, c'est en secondes (format ss.xx)
      double secondes = _parseDouble(tempsStr) ?? 0;
      if (secondes < 0) {
        return -1;
      }
      return secondes;
    } catch (e) {
      return -1; // Erreur
    }
  }

  String _formatResultAvecCentiemes(double seconds) {
    int minutes = (seconds ~/ 60).toInt();
    double secondesDecimal = seconds % 60;

    // Correction: gérer le cas où secondesDecimal >= 60
    if (secondesDecimal >= 60) {
      minutes += (secondesDecimal ~/ 60).toInt();
      secondesDecimal = secondesDecimal % 60;
    }

    // Formater avec 2 décimales
    if (minutes > 0) {
      return '${minutes}:${secondesDecimal.toStringAsFixed(2).padLeft(5, '0')}';
    } else {
      return '${secondesDecimal.toStringAsFixed(2)} sec';
    }
  }

  double? _parseDouble(String value) {
    if (value.trim().isEmpty) {
      return null;
    }
    try {
      // Gérer la virgule française
      value = value.replaceAll(',', '.');
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
