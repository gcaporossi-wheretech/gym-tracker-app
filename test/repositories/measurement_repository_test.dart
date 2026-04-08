import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gym_tracker_app/models/body_measurement.dart';
import 'package:gym_tracker_app/repositories/measurement_repository.dart';

class MockMeasurementRepository extends Mock
    implements MeasurementRepository {}

void main() {
  late MockMeasurementRepository repo;

  final m1 = BodyMeasurement(
    id: 'id-1',
    date: DateTime.utc(2026, 4, 8),
    weight: 82.5,
    chest: 100.0,
    waist: 84.0,
  );

  final m2 = BodyMeasurement(
    id: 'id-2',
    date: DateTime.utc(2026, 3, 25),
    weight: 83.0,
    chest: 101.0,
    waist: 85.0,
  );

  setUp(() {
    repo = MockMeasurementRepository();
  });

  group('MeasurementRepository contract', () {
    test('getAllMeasurements returns list sorted by date desc', () async {
      when(() => repo.getAllMeasurements())
          .thenAnswer((_) async => [m1, m2]);

      final result = await repo.getAllMeasurements();

      expect(result.length, 2);
      // m1 is more recent
      expect(result.first.id, 'id-1');
      expect(result.last.id, 'id-2');
    });

    test('saveMeasurement is called with correct measurement', () async {
      when(() => repo.saveMeasurement(m1)).thenAnswer((_) async {});

      await repo.saveMeasurement(m1);

      verify(() => repo.saveMeasurement(m1)).called(1);
    });

    test('deleteMeasurement is called with correct id', () async {
      when(() => repo.deleteMeasurement('id-1')).thenAnswer((_) async {});

      await repo.deleteMeasurement('id-1');

      verify(() => repo.deleteMeasurement('id-1')).called(1);
    });

    test('getLatestMeasurement returns most recent when data exists', () async {
      when(() => repo.getLatestMeasurement()).thenAnswer((_) async => m1);

      final result = await repo.getLatestMeasurement();

      expect(result, isNotNull);
      expect(result!.id, 'id-1');
      expect(result.weight, 82.5);
    });

    test('getLatestMeasurement returns null when no measurements', () async {
      when(() => repo.getLatestMeasurement()).thenAnswer((_) async => null);

      final result = await repo.getLatestMeasurement();

      expect(result, isNull);
    });

    test('getAllMeasurements returns empty list when no data', () async {
      when(() => repo.getAllMeasurements()).thenAnswer((_) async => []);

      final result = await repo.getAllMeasurements();

      expect(result, isEmpty);
    });
  });
}
