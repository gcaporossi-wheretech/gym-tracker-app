import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/body_measurement.dart';
import 'measurement_repository.dart';

class HiveMeasurementRepository implements MeasurementRepository {
  static const String _boxName = 'body_measurements';

  late Box<String> _box;

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  @override
  Future<List<BodyMeasurement>> getAllMeasurements() async {
    final measurements = _box.values
        .map((json) =>
            BodyMeasurement.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
    measurements.sort((a, b) => b.date.compareTo(a.date));
    return measurements;
  }

  @override
  Future<void> saveMeasurement(BodyMeasurement measurement) async {
    await _box.put(measurement.id, jsonEncode(measurement.toJson()));
  }

  @override
  Future<void> deleteMeasurement(String measurementId) async {
    await _box.delete(measurementId);
  }

  @override
  Future<BodyMeasurement?> getLatestMeasurement() async {
    final all = await getAllMeasurements();
    return all.isEmpty ? null : all.first; // already sorted desc by date
  }
}
