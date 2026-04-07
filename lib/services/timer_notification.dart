/// Platform-agnostic timer notification.
/// On web: plays beep + vibration. On other platforms: no-op.
class TimerNotification {
  static void unlockAudio() {}
  static void notify() {}
  static void tick() {}
}
