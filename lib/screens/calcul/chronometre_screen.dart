import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/dimens.dart';

class ChronometreScreen extends StatefulWidget {
  const ChronometreScreen({super.key});

  @override
  _ChronometreScreenState createState() => _ChronometreScreenState();
}

class _ChronometreScreenState extends State<ChronometreScreen> {
  bool _running = false;
  DateTime? _startTime;
  Duration _elapsedTime = Duration.zero;
  Duration _lastLapTime = Duration.zero;
  final List<LapRecord> _laps = [];

  @override
  void dispose() {
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
                  'Chronomètre',
                  style: TextStyle(
                    color: AppColors.blanc,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mesurez vos performances',
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
                  // Carte chronomètre
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
                        children: [
                          // Affichage du temps
                          Container(
                            width: double.infinity,
                            height: 160,
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
                                _formatTime(_elapsedTime),
                                style: const TextStyle(
                                  color: AppColors.rougeAcr,
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Boutons de contrôle
                          Row(
                            children: [
                              // START/STOP
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 70,
                                  child: ElevatedButton(
                                    onPressed: _toggleChronometer,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _running
                                          ? AppColors.rougeAcrDark
                                          : AppColors.rougeAcr,
                                      foregroundColor: AppColors.blanc,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.borderRadiusXLarge,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      _running ? 'STOP' : 'START',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              // TOUR
                              Expanded(
                                child: SizedBox(
                                  height: 70,
                                  child: ElevatedButton(
                                    onPressed: _running ? _recordLap : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.blanc,
                                      foregroundColor: AppColors.rougeAcrDark,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.borderRadiusXLarge,
                                        ),
                                        side: BorderSide(
                                          color: AppColors.rougeAcrDark,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'TOUR',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              // RESET
                              Expanded(
                                child: SizedBox(
                                  height: 70,
                                  child: ElevatedButton(
                                    onPressed: _resetChronometer,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.blanc,
                                      foregroundColor: AppColors.rougeAcrDark,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.borderRadiusXLarge,
                                        ),
                                        side: BorderSide(
                                          color: AppColors.rougeAcrDark,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'R',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Carte tours
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
                          Text(
                            'TOURS',
                            style: TextStyle(
                              color: AppColors.rougeAcrDark,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Container(
                            width: double.infinity,
                            height: 400,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.rougeAcr,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimens.borderRadiusMedium,
                              ),
                            ),
                            child: _laps.isEmpty
                                ? Center(
                                    child: Text(
                                      'Aucun tour enregistré',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _laps.reversed.map((lap) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: Text(
                                            lap.getFormattedLap(),
                                            style: const TextStyle(
                                              color: AppColors.noir,
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bouton Retour
                  SizedBox(
                    width: double.infinity,
                    height: AppDimens.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blanc,
                        foregroundColor: AppColors.rougeAcrDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.borderRadiusXLarge,
                          ),
                          side: BorderSide(
                            color: AppColors.rougeAcrDark,
                            width: 2,
                          ),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        'RETOUR AU MENU',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  void _toggleChronometer() {
    if (!_running) {
      _startChronometer();
    } else {
      _stopChronometer();
    }
  }

  void _startChronometer() {
    if (!_running) {
      setState(() {
        if (_elapsedTime == Duration.zero) {
          _startTime = DateTime.now();
          _lastLapTime = Duration.zero;
        } else {
          _startTime = DateTime.now().subtract(_elapsedTime);
        }
        _running = true;
      });

      // Mettre à jour le temps
      _updateTimer();
    }
  }

  void _stopChronometer() {
    if (_running) {
      setState(() {
        _running = false;
      });
    }
  }

  void _updateTimer() {
    if (_running) {
      Future.delayed(const Duration(milliseconds: 10), () {
        if (_running && _startTime != null) {
          setState(() {
            _elapsedTime = DateTime.now().difference(_startTime!);
          });
          _updateTimer();
        }
      });
    }
  }

  void _recordLap() {
    if (_running && _startTime != null) {
      DateTime currentTime = DateTime.now();
      Duration lapTime = currentTime.difference(_startTime!.add(_lastLapTime));
      Duration totalTimeAtLap = currentTime.difference(_startTime!);
      int lapNumber = _laps.length + 1;

      LapRecord lapRecord = LapRecord(
        lapTime: lapTime,
        totalTime: totalTimeAtLap,
        lapNumber: lapNumber,
      );

      setState(() {
        _laps.add(lapRecord);
        _lastLapTime = totalTimeAtLap;
      });
    }
  }

  void _resetChronometer() {
    setState(() {
      _running = false;
      _startTime = null;
      _elapsedTime = Duration.zero;
      _lastLapTime = Duration.zero;
      _laps.clear();
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitsMillis(int n) => n.toString().padLeft(2, '0');

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    int milliseconds = duration.inMilliseconds.remainder(1000) ~/ 10;

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}.${twoDigitsMillis(milliseconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}.${twoDigitsMillis(milliseconds)}';
    }
  }
}

class LapRecord {
  final Duration lapTime;
  final Duration totalTime;
  final int lapNumber;

  LapRecord({
    required this.lapTime,
    required this.totalTime,
    required this.lapNumber,
  });

  String getFormattedLap() {
    String formatDuration(Duration d) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitsMillis(int n) => n.toString().padLeft(2, '0');

      int minutes = d.inMinutes.remainder(60);
      int seconds = d.inSeconds.remainder(60);
      int milliseconds = d.inMilliseconds.remainder(1000) ~/ 10;

      return '${twoDigits(minutes)}:${twoDigits(seconds)}.${twoDigitsMillis(milliseconds)}';
    }

    return 'Tour $lapNumber:  ${formatDuration(lapTime)}  (Total: ${formatDuration(totalTime)})';
  }
}
