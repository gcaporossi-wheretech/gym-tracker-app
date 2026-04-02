import 'dart:async';

import 'package:flutter/foundation.dart';

/// Service per il timer di recupero tra le serie.
/// Usa timestamp assoluto cosi il timer prosegue anche fuori dall'app (GYM-22).
class RestTimerService extends ChangeNotifier {
  Timer? _timer;
  DateTime? _endTime;
  int _totalSeconds = 0;
  bool _isRunning = false;

  int get remainingSeconds {
    if (_endTime == null) return 0;
    final remaining = _endTime!.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  int get totalSeconds => _totalSeconds;
  bool get isRunning => _isRunning && remainingSeconds > 0;

  double get progress {
    if (_totalSeconds <= 0) return 0;
    return 1.0 - (remainingSeconds / _totalSeconds);
  }

  String get formattedTime {
    final sec = remainingSeconds;
    final min = sec ~/ 60;
    final s = sec % 60;
    return '${min.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// Avvia il timer con i secondi specificati
  void start(int seconds) {
    stop();
    _totalSeconds = seconds;
    _endTime = DateTime.now().add(Duration(seconds: seconds));
    _isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds <= 0) {
        _isRunning = false;
        _timer?.cancel();
        _timer = null;
      }
      notifyListeners();
    });
  }

  /// Aggiungi 30 secondi
  void addThirtySeconds() {
    if (_endTime != null) {
      _endTime = _endTime!.add(const Duration(seconds: 30));
      _totalSeconds += 30;
    }
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (remainingSeconds <= 0) {
          _isRunning = false;
          _timer?.cancel();
          _timer = null;
        }
        notifyListeners();
      });
    }
    notifyListeners();
  }

  /// Salta il timer
  void skip() {
    stop();
  }

  /// Ferma il timer
  void stop() {
    _timer?.cancel();
    _timer = null;
    _endTime = null;
    _totalSeconds = 0;
    _isRunning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
