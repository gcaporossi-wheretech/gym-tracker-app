import 'dart:async';

import 'package:flutter/foundation.dart';

/// Service per il timer di recupero tra le serie.
/// Gestisce countdown, notifica completamento, e azioni +30s/skip.
class RestTimerService extends ChangeNotifier {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _isRunning = false;

  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  bool get isRunning => _isRunning;
  double get progress =>
      _totalSeconds > 0 ? 1.0 - (_remainingSeconds / _totalSeconds) : 0;

  String get formattedTime {
    final min = _remainingSeconds ~/ 60;
    final sec = _remainingSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  /// Avvia il timer con i secondi specificati
  void start(int seconds) {
    stop();
    _totalSeconds = seconds;
    _remainingSeconds = seconds;
    _isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _remainingSeconds--;
      if (_remainingSeconds <= 0) {
        _remainingSeconds = 0;
        _isRunning = false;
        _timer?.cancel();
        _timer = null;
      }
      notifyListeners();
    });
  }

  /// Aggiungi 30 secondi
  void addThirtySeconds() {
    _remainingSeconds += 30;
    _totalSeconds += 30;
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
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
    _remainingSeconds = 0;
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
