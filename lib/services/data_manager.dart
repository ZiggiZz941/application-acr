import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart'; // AJOUTEZ CET IMPORT
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../models/seance.dart';

class DataManager extends ChangeNotifier {
  static const String _keyUserNom = "user_nom";
  static const String _keyUserPrenom = "user_prenom";
  static const String _keyFirstLaunch = "first_launch";
  static const String _fileName = "seances.json";
  static const int _maxSeances = 25;

  late SharedPreferences _prefs;

  DataManager();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  // ========== GESTION UTILISATEUR ==========
  Future<void> saveUser(String nom, String prenom) async {
    await _prefs.setString(_keyUserNom, nom);
    await _prefs.setString(_keyUserPrenom, prenom);
    await _prefs.setBool(_keyFirstLaunch, false);
    notifyListeners();
  }

  String getUserNom() {
    return _prefs.getString(_keyUserNom) ?? "";
  }

  String getUserPrenom() {
    return _prefs.getString(_keyUserPrenom) ?? "";
  }

  bool isFirstLaunch() {
    return _prefs.getBool(_keyFirstLaunch) ?? true;
  }

  // ========== GESTION SÉANCES ==========
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<bool> saveSeance(Seance seance) async {
    try {
      List<Seance> seances = await loadAllSeances();

      // Chercher si la séance existe déjà
      bool found = false;
      for (int i = 0; i < seances.length; i++) {
        if (seances[i].id == seance.id) {
          seances[i] = seance;
          found = true;
          break;
        }
      }

      // Si nouvelle séance
      if (!found) {
        if (seance.id == 0) {
          seance.id = _generateSeanceId(seances);
        }
        seances.insert(0, seance);

        // Limiter à _maxSeances
        if (seances.length > _maxSeances) {
          seances = seances.sublist(0, _maxSeances);
        }
      }

      // Sauvegarder toutes les séances
      final saved = await _saveAllSeances(seances);
      if (saved) notifyListeners();
      return saved;
    } catch (e) {
      print("Erreur sauvegarde séance: $e");
      return false;
    }
  }

  Future<List<Seance>> loadAllSeances() async {
    try {
      final file = await _getLocalFile();

      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return [];
      }

      List<dynamic> jsonArray = json.decode(contents);
      return jsonArray
          .map((json) => Seance.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Erreur chargement séances: $e");
      return [];
    }
  }

  Future<List<Seance>> loadSeancesWithLimit(int limit) async {
    List<Seance> allSeances = await loadAllSeances();
    if (allSeances.length <= limit) {
      return allSeances;
    }
    return allSeances.sublist(0, limit);
  }

  Future<bool> deleteSeance(int seanceId) async {
    try {
      List<Seance> seances = await loadAllSeances();
      int initialSize = seances.length;
      seances.removeWhere((seance) => seance.id == seanceId);

      if (seances.length < initialSize) {
        final saved = await _saveAllSeances(seances);
        if (saved) notifyListeners();
        return saved;
      }
      return false;
    } catch (e) {
      print("Erreur suppression séance: $e");
      return false;
    }
  }

  Future<bool> clearAllSeances() async {
    try {
      final saved = await _saveAllSeances([]);
      if (saved) notifyListeners();
      return saved;
    } catch (e) {
      print("Erreur suppression toutes séances: $e");
      return false;
    }
  }

  Future<int> getSeancesCount() async {
    List<Seance> seances = await loadAllSeances();
    return seances.length;
  }

  Future<bool> isLimitReached() async {
    int count = await getSeancesCount();
    return count >= _maxSeances;
  }

  // ========== MÉTHODES PRIVÉES ==========
  Future<bool> _saveAllSeances(List<Seance> seances) async {
    try {
      final file = await _getLocalFile();
      List<Map<String, dynamic>> jsonList = seances
          .map((seance) => seance.toJson())
          .toList();

      String jsonString = json.encode(jsonList);
      await file.writeAsString(jsonString);
      return true;
    } catch (e) {
      print("Erreur sauvegarde toutes séances: $e");
      return false;
    }
  }

  int _generateSeanceId(List<Seance> seances) {
    int maxId = 0;
    for (Seance seance in seances) {
      if (seance.id > maxId) {
        maxId = seance.id;
      }
    }
    return maxId + 1;
  }

  // ========== MÉTHODES UTILITAIRES ==========
  Future<String> debugGetJsonContent() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) {
        return "Aucun fichier JSON trouvé";
      }
      return await file.readAsString();
    } catch (e) {
      return "Erreur : $e";
    }
  }

  Future<void> debugClearAllData() async {
    // Supprimer le fichier JSON
    final file = await _getLocalFile();
    if (await file.exists()) {
      await file.delete();
    }

    // Supprimer les SharedPreferences
    await _prefs.clear();
    notifyListeners();
  }
}
