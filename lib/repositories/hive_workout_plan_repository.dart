import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/workout_plan.dart';
import 'workout_plan_repository.dart';

class HiveWorkoutPlanRepository implements WorkoutPlanRepository {
  static const String _boxName = 'workout_plans';
  static const String _activeKey = 'active_plan_id';

  late Box<String> _box;
  late Box<String> _metaBox;

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
    _metaBox = await Hive.openBox<String>('meta');
  }

  @override
  Future<WorkoutPlan?> getActivePlan() async {
    final activeId = _metaBox.get(_activeKey);
    if (activeId == null) return null;
    final json = _box.get(activeId);
    if (json == null) return null;
    return WorkoutPlan.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  @override
  Future<void> savePlan(WorkoutPlan plan) async {
    await _box.put(plan.id, jsonEncode(plan.toJson()));
    // Il primo piano salvato diventa automaticamente attivo
    if (_metaBox.get(_activeKey) == null) {
      await _metaBox.put(_activeKey, plan.id);
    }
  }

  @override
  Future<void> deletePlan(String planId) async {
    await _box.delete(planId);
    if (_metaBox.get(_activeKey) == planId) {
      await _metaBox.delete(_activeKey);
    }
  }

  @override
  Future<List<WorkoutPlan>> getAllPlans() async {
    return _box.values
        .map((json) =>
            WorkoutPlan.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
  }
}
