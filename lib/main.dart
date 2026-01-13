import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/data_manager.dart';
import 'screens/main_menu_screen.dart';
import 'screens/premiere_connexion_screen.dart';
import 'constants/colors.dart';
import 'constants/dimens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser le DataManager
  final DataManager dataManager = DataManager();
  await dataManager.init();

  runApp(MyApp(dataManager: dataManager));
}

class MyApp extends StatelessWidget {
  final DataManager dataManager;

  const MyApp({super.key, required this.dataManager});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: dataManager,
      child: MaterialApp(
        title: 'ACR Calcul Temps',
        theme: ThemeData(
          primaryColor: AppColors.rougeAcr,
          primaryColorDark: AppColors.rougeAcrDark,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.rougeAcr,
            secondary: AppColors.rougeAcrLight,
          ),
          scaffoldBackgroundColor: AppColors.grisFond,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.rougeAcrDark,
            elevation: 0,
            centerTitle: true,
          ),
          // SUPPRIMEZ CardTheme ICI - on utilisera les valeurs par défaut
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rougeAcr,
              foregroundColor: AppColors.blanc,
              minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDimens.borderRadiusXLarge,
                ),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.blanc,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
              borderSide: BorderSide(color: AppColors.rougeAcr, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
              borderSide: BorderSide(color: AppColors.rougeAcr, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
              borderSide: BorderSide(color: AppColors.rougeAcrDark, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingMedium,
              vertical: AppDimens.paddingMedium,
            ),
          ),
        ),
        home: FutureBuilder<bool>(
          future: Future.value(dataManager.isFirstLaunch()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (snapshot.data == true || dataManager.getUserNom().isEmpty) {
              return const PremiereConnexionScreen();
            } else {
              return const MainMenuScreen();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.rougeAcr,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_run, size: 100, color: AppColors.blanc),
            const SizedBox(height: 20),
            Text(
              'ACR Athlétisme',
              style: TextStyle(
                color: AppColors.blanc,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: AppColors.blanc),
          ],
        ),
      ),
    );
  }
}
