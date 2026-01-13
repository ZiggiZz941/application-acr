class Exercice {
  int id;
  String nom;
  double distance;
  int nbSeries;
  int nbRepetitions;
  double vma;
  int allure;
  int reposRepetitionsSec;
  int reposSeriesSec;
  double tempsMin;
  double tempsMax;

  Exercice({
    this.id = 0,
    required this.nom,
    required this.distance,
    required this.nbSeries,
    required this.nbRepetitions,
    required this.vma,
    required this.allure,
    required this.reposRepetitionsSec,
    required this.reposSeriesSec,
  }) : tempsMin = 0,
       tempsMax = 0 {
    calculerTemps();
  }

  // Méthode de conversion temps
  static int parseTempsEnSecondes(String tempsStr) {
    if (tempsStr.trim().isEmpty) {
      return 0;
    }

    try {
      if (tempsStr.contains(":")) {
        List<String> parties = tempsStr.split(":");
        if (parties.length == 2) {
          int minutes = int.parse(parties[0]);
          int secondes = int.parse(parties[1]);
          return (minutes * 60) + secondes;
        }
      }
      return int.parse(tempsStr);
    } catch (e) {
      return 0;
    }
  }

  static String formatTempsEnMinutes(int secondes) {
    if (secondes <= 0) return "0:00";

    int minutes = secondes ~/ 60;
    int sec = secondes % 60;
    return "$minutes:${sec.toString().padLeft(2, '0')}";
  }

  void calculerTemps() {
    if (vma <= 0) return;

    double vitesseMs = vma / 3.6;
    double tempsBase100 = distance / vitesseMs;

    double pourcentageMin, pourcentageMax;
    switch (allure) {
      case 1:
        pourcentageMin = 60;
        pourcentageMax = 70;
        break;
      case 2:
        pourcentageMin = 70;
        pourcentageMax = 80;
        break;
      case 3:
        pourcentageMin = 80;
        pourcentageMax = 85;
        break;
      case 4:
        pourcentageMin = 85;
        pourcentageMax = 90;
        break;
      case 5:
        pourcentageMin = 90;
        pourcentageMax = 95;
        break;
      case 6:
        pourcentageMin = 100;
        pourcentageMax = 100;
        break;
      default:
        pourcentageMin = 80;
        pourcentageMax = 85;
    }

    tempsMax = tempsBase100 / (pourcentageMin / 100.0);
    tempsMin = tempsBase100 / (pourcentageMax / 100.0);
  }

  String getDescription() {
    String tempsMinStr = formatTemps(tempsMin);
    String tempsMaxStr = formatTemps(tempsMax);

    StringBuffer sb = StringBuffer();

    if (nbRepetitions > 1) {
      sb.write("${nbSeries}x${nbRepetitions}x${distance.toInt()}m");
    } else {
      sb.write("${nbSeries}x${distance.toInt()}m");
    }

    if (allure == 6) {
      sb.write(" à $tempsMinStr");
    } else {
      sb.write(" entre $tempsMinStr et $tempsMaxStr");
    }

    if (reposRepetitionsSec > 0 || (reposSeriesSec > 0 && nbSeries > 1)) {
      sb.write(" (");
      bool premiereInfo = true;

      if (reposRepetitionsSec > 0) {
        sb.write("repos: ${formatTempsEnMinutes(reposRepetitionsSec)}");
        premiereInfo = false;
      }

      if (reposSeriesSec > 0 && nbSeries > 1) {
        if (!premiereInfo) sb.write(" / ");
        sb.write("série: ${formatTempsEnMinutes(reposSeriesSec)}");
      }

      sb.write(")");
    }

    return sb.toString();
  }

  String getDescriptionDetaillee() {
    String tempsMinStr = formatTemps(tempsMin);
    String tempsMaxStr = formatTemps(tempsMax);

    StringBuffer sb = StringBuffer();

    sb.write("${nbSeries} séries");

    if (nbRepetitions > 1) {
      sb.write(" de $nbRepetitions répétitions");
    }

    sb.write(" de ${distance.toInt()}m\n");

    if (allure == 6) {
      sb.write("Temps: $tempsMinStr par répétition\n");
    } else {
      sb.write("Temps: $tempsMinStr à $tempsMaxStr par répétition\n");
    }

    if (reposRepetitionsSec > 0) {
      sb.write(
        "Repos entre répétitions: ${formatTempsEnMinutes(reposRepetitionsSec)}\n",
      );
    }

    if (reposSeriesSec > 0 && nbSeries > 1) {
      sb.write("Repos entre séries: ${formatTempsEnMinutes(reposSeriesSec)}");
    }

    return sb.toString();
  }

  String formatTemps(double seconds) {
    int minutes = (seconds ~/ 60).toInt();
    int secondes = (seconds % 60).round();

    if (secondes == 60) {
      minutes++;
      secondes = 0;
    }

    return "${minutes}:${secondes.toString().padLeft(2, '0')}";
  }

  // Getters
  String get reposRepetitionsFormate =>
      formatTempsEnMinutes(reposRepetitionsSec);
  String get reposSeriesFormate => formatTempsEnMinutes(reposSeriesSec);

  // JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'distance': distance,
      'nbSeries': nbSeries,
      'nbRepetitions': nbRepetitions,
      'vma': vma,
      'allure': allure,
      'reposRepetitionsSec': reposRepetitionsSec,
      'reposSeriesSec': reposSeriesSec,
      'tempsMinSecondes': tempsMin,
      'tempsMaxSecondes': tempsMax,
      'reposRepetitionsFormate': reposRepetitionsFormate,
      'reposSeriesFormate': reposSeriesFormate,
      'tempsMinFormate': formatTemps(tempsMin),
      'tempsMaxFormate': formatTemps(tempsMax),
      'description': getDescription(),
      'descriptionDetaillee': getDescriptionDetaillee(),
    };
  }

  factory Exercice.fromJson(Map<String, dynamic> json) {
    Exercice exercice = Exercice(
      nom: json['nom'],
      distance: (json['distance'] as num).toDouble(),
      nbSeries: json['nbSeries'],
      nbRepetitions: json['nbRepetitions'] ?? 1,
      vma: (json['vma'] as num).toDouble(),
      allure: json['allure'],
      reposRepetitionsSec:
          json['reposRepetitionsSec'] ?? json['reposRepetitions'] ?? 0,
      reposSeriesSec: json['reposSeriesSec'] ?? json['reposSeries'] ?? 0,
    );

    exercice.id = json['id'];

    if (json.containsKey('tempsMinSecondes')) {
      exercice.tempsMin = (json['tempsMinSecondes'] as num).toDouble();
      exercice.tempsMax = (json['tempsMaxSecondes'] as num).toDouble();
    } else {
      exercice.tempsMin = (json['tempsMin'] as num).toDouble();
      exercice.tempsMax = (json['tempsMax'] as num).toDouble();
    }

    return exercice;
  }
}
