import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/models/set_log.dart';

void main() {
  group('SetLog', () {
    test('should create with required fields and defaults', () {
      const setLog = SetLog(setNumber: 1, plannedReps: 8);

      expect(setLog.setNumber, 1);
      expect(setLog.plannedReps, 8);
      expect(setLog.actualReps, 0);
      expect(setLog.weight, 0);
      expect(setLog.completed, false);
    });

    test('should create with all fields', () {
      const setLog = SetLog(
        setNumber: 2,
        plannedReps: 8,
        actualReps: 8,
        weight: 42.5,
        rpe: 8,
        notes: 'Ultimo rep duro',
        completed: true,
      );

      expect(setLog.weight, 42.5);
      expect(setLog.rpe, 8);
      expect(setLog.notes, 'Ultimo rep duro');
      expect(setLog.completed, true);
    });

    test('should serialize to JSON and back', () {
      const original = SetLog(
        setNumber: 1,
        plannedReps: 8,
        actualReps: 8,
        weight: 50,
        rpe: 7.5,
        notes: 'Buono',
        completed: true,
      );

      final json = original.toJson();
      final restored = SetLog.fromJson(json);

      expect(restored, original);
    });

    test('should survive JSON string round-trip', () {
      const original = SetLog(
        setNumber: 3,
        plannedReps: 12,
        actualReps: 10,
        weight: 22.5,
      );

      final jsonString = jsonEncode(original.toJson());
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final restored = SetLog.fromJson(decoded);

      expect(restored.setNumber, 3);
      expect(restored.weight, 22.5);
    });

    test('should support copyWith', () {
      const original = SetLog(setNumber: 1, plannedReps: 8);
      final updated = original.copyWith(actualReps: 8, weight: 50, completed: true);

      expect(updated.actualReps, 8);
      expect(updated.weight, 50);
      expect(updated.completed, true);
      expect(original.completed, false); // immutable
    });
  });
}
