import '../models/body_measurement.dart';

/// Abstract repository for body measurements
abstract class MeasurementRepository {
  Future<List<BodyMeasurement>> getAllMeasurements();
  Future<void> saveMeasurement(BodyMeasurement measurement);
  Future<void> deleteMeasurement(String measurementId);
  Future<BodyMeasurement?> getLatestMeasurement();
}
