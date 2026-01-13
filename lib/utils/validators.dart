class Validators {
  // Valider un nombre
  static String? validateNumber(
    String? value, {
    String fieldName = 'Ce champ',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est obligatoire';
    }

    try {
      double parsed = double.parse(value.replaceAll(',', '.'));
      if (parsed <= 0) {
        return '$fieldName doit être positif';
      }
      return null;
    } catch (e) {
      return '$fieldName doit être un nombre valide';
    }
  }

  // Valider un entier
  static String? validateInteger(
    String? value, {
    String fieldName = 'Ce champ',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est obligatoire';
    }

    try {
      int parsed = int.parse(value);
      if (parsed <= 0) {
        return '$fieldName doit être positif';
      }
      return null;
    } catch (e) {
      return '$fieldName doit être un nombre entier valide';
    }
  }

  // Valider un pourcentage (1-100)
  static String? validatePercentage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le pourcentage est obligatoire';
    }

    try {
      double parsed = double.parse(value.replaceAll(',', '.'));
      if (parsed <= 0 || parsed > 100) {
        return 'Le pourcentage doit être entre 1 et 100%';
      }
      return null;
    } catch (e) {
      return 'Pourcentage invalide';
    }
  }

  // Valider un temps (format mm:ss ou ss.xx)
  static String? validateTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le temps est obligatoire';
    }

    try {
      // Essayer de parser comme mm:ss
      if (value.contains(':')) {
        List<String> parts = value.split(':');
        if (parts.length == 2) {
          int minutes = int.parse(parts[0]);
          double seconds = double.parse(parts[1].replaceAll(',', '.'));
          if (minutes < 0 || seconds < 0 || seconds >= 60) {
            return 'Format de temps invalide (mm:ss.xx)';
          }
          return null;
        }
      }

      // Essayer de parser comme secondes
      double seconds = double.parse(value.replaceAll(',', '.'));
      if (seconds < 0) {
        return 'Le temps doit être positif';
      }
      return null;
    } catch (e) {
      return 'Format de temps invalide. Utilisez mm:ss.xx ou ss.xx';
    }
  }

  // Valider un nom (non vide)
  static String? validateName(String? value, {String fieldName = 'Le nom'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est obligatoire';
    }
    return null;
  }
}
