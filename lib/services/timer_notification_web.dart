import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web implementation: play beep sound and vibrate when timer finishes.
/// Requires a prior user tap to unlock AudioContext on mobile browsers.
class TimerNotification {
  static web.AudioContext? _audioCtx;

  /// Must be called once from a user gesture (tap) to unlock audio on iOS.
  static void unlockAudio() {
    _audioCtx ??= web.AudioContext();
    _audioCtx!.resume();
  }

  /// Play a short beep sequence and vibrate.
  static void notify() {
    _playBeep();
    _vibrate();
  }

  static void _playBeep() {
    try {
      final ctx = _audioCtx ?? web.AudioContext();
      _audioCtx = ctx;

      final now = ctx.currentTime;
      // Three short beeps at 880Hz
      for (var i = 0; i < 3; i++) {
        final osc = ctx.createOscillator();
        final gain = ctx.createGain();
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.frequency.value = 880;
        gain.gain.value = 0.4;
        osc.start(now + i * 0.25);
        osc.stop(now + i * 0.25 + 0.15);
      }
    } catch (_) {
      // Audio not available - fail silently
    }
  }

  static void _vibrate() {
    try {
      web.window.navigator.vibrate(200.toJS);
    } catch (_) {
      // Vibration not supported - fail silently
    }
  }
}
