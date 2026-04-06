import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/services/rest_timer_service.dart';

void main() {
  group('RestTimerService', () {
    late RestTimerService timer;

    setUp(() {
      timer = RestTimerService();
    });

    tearDown(() {
      timer.dispose();
    });

    test('starts with default values', () {
      expect(timer.isRunning, false);
      expect(timer.remainingSeconds, 0);
      expect(timer.totalSeconds, 0);
      expect(timer.progress, 0);
    });

    test('start sets correct initial state', () {
      timer.start(120);
      expect(timer.isRunning, true);
      // remainingSeconds is calculated from timestamp, allow 1 second tolerance
      expect(timer.remainingSeconds, closeTo(120, 1));
      expect(timer.totalSeconds, 120);
    });

    test('formattedTime shows MM:SS format', () {
      timer.start(90);
      // Allow 1 second tolerance due to timestamp-based calculation
      expect(timer.formattedTime, anyOf('01:30', '01:29'));

      timer.start(5);
      expect(timer.formattedTime, anyOf('00:05', '00:04'));
    });

    test('skip stops the timer', () {
      timer.start(120);
      expect(timer.isRunning, true);

      timer.skip();
      expect(timer.isRunning, false);
      expect(timer.remainingSeconds, 0);
    });

    test('addThirtySeconds increases time', () {
      timer.start(60);
      timer.addThirtySeconds();
      expect(timer.remainingSeconds, closeTo(90, 1));
      expect(timer.totalSeconds, 90);
    });

    test('stop resets everything', () {
      timer.start(120);
      timer.stop();
      expect(timer.isRunning, false);
      expect(timer.remainingSeconds, 0);
      expect(timer.totalSeconds, 0);
    });

    test('notifies listeners on start', () {
      var notified = false;
      timer.addListener(() => notified = true);
      timer.start(60);
      expect(notified, true);
    });
  });
}
