import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/models/body_measurement.dart';

void main() {
  group('BodyMeasurement', () {
    late BodyMeasurement measurement;

    setUp(() {
      measurement = BodyMeasurement(
        id: 'meas-1',
        date: DateTime.utc(2026, 4, 8),
        weight: 82.5,
        chest: 100.0,
        waist: 84.0,
        hips: 95.0,
        shoulders: 118.0,
        bicepLeft: 37.5,
        bicepRight: 38.0,
        thighLeft: 58.0,
        thighRight: 58.5,
        calfLeft: 38.0,
        calfRight: 38.0,
        notes: 'Dopo colazione',
      );
    });

    test('should hold all field values correctly', () {
      expect(measurement.id, 'meas-1');
      expect(measurement.weight, 82.5);
      expect(measurement.chest, 100.0);
      expect(measurement.waist, 84.0);
      expect(measurement.hips, 95.0);
      expect(measurement.shoulders, 118.0);
      expect(measurement.bicepLeft, 37.5);
      expect(measurement.bicepRight, 38.0);
      expect(measurement.thighLeft, 58.0);
      expect(measurement.thighRight, 58.5);
      expect(measurement.calfLeft, 38.0);
      expect(measurement.calfRight, 38.0);
      expect(measurement.notes, 'Dopo colazione');
    });

    test('should have default values of 0 for all numeric fields', () {
      final empty = BodyMeasurement(
        id: 'empty',
        date: DateTime.utc(2026, 1, 1),
      );
      expect(empty.weight, 0);
      expect(empty.chest, 0);
      expect(empty.waist, 0);
      expect(empty.hips, 0);
      expect(empty.shoulders, 0);
      expect(empty.bicepLeft, 0);
      expect(empty.bicepRight, 0);
      expect(empty.thighLeft, 0);
      expect(empty.thighRight, 0);
      expect(empty.calfLeft, 0);
      expect(empty.calfRight, 0);
      expect(empty.notes, '');
    });

    test('should serialize to JSON and back (round-trip)', () {
      final json = measurement.toJson();
      final restored = BodyMeasurement.fromJson(json);

      expect(restored.id, measurement.id);
      expect(restored.weight, measurement.weight);
      expect(restored.chest, measurement.chest);
      expect(restored.waist, measurement.waist);
      expect(restored.notes, measurement.notes);
      expect(restored.date, measurement.date);
    });

    test('should serialize through jsonEncode/jsonDecode (Hive storage)', () {
      final jsonString = jsonEncode(measurement.toJson());
      final restored = BodyMeasurement.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>);

      expect(restored.id, measurement.id);
      expect(restored.weight, measurement.weight);
      expect(restored.bicepLeft, measurement.bicepLeft);
      expect(restored.bicepRight, measurement.bicepRight);
    });

    test('copyWith should produce updated instance', () {
      final updated = measurement.copyWith(weight: 81.0, notes: 'A digiuno');

      expect(updated.weight, 81.0);
      expect(updated.notes, 'A digiuno');
      // Unchanged fields remain
      expect(updated.chest, measurement.chest);
      expect(updated.id, measurement.id);
    });

    test('two instances with same values should be equal (freezed ==)', () {
      final a = BodyMeasurement(
        id: 'x',
        date: DateTime.utc(2026, 4, 8),
        weight: 80.0,
      );
      final b = BodyMeasurement(
        id: 'x',
        date: DateTime.utc(2026, 4, 8),
        weight: 80.0,
      );
      expect(a, equals(b));
    });
  });
}
