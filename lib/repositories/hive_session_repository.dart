import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/workout_session.dart';
import 'session_repository.dart';

class HiveSessionRepository implements SessionRepository {
  static const String _boxName = 'workout_sessions';
  static const String _activeSessionKey = 'active_session_id';

  late Box<String> _box;
  late Box<String> _metaBox;

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
    _metaBox = await Hive.openBox<String>('meta');
  }

  @override
  Future<List<WorkoutSession>> getAllSessions() async {
    final sessions = _box.values
        .map((json) =>
            WorkoutSession.fromJson(jsonDecode(json) as Map<String, dynamic>))
        .toList();
    sessions.sort((a, b) => b.date.compareTo(a.date));
    return sessions;
  }

  @override
  Future<List<WorkoutSession>> getSessionsInRange(
      DateTime from, DateTime to) async {
    final all = await getAllSessions();
    return all
        .where((s) =>
            s.date.isAfter(from.subtract(const Duration(days: 1))) &&
            s.date.isBefore(to.add(const Duration(days: 1))))
        .toList();
  }

  @override
  Future<WorkoutSession?> getSession(String sessionId) async {
    final json = _box.get(sessionId);
    if (json == null) return null;
    return WorkoutSession.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  @override
  Future<void> saveSession(WorkoutSession session) async {
    await _box.put(session.id, jsonEncode(session.toJson()));
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await _box.delete(sessionId);
    if (_metaBox.get(_activeSessionKey) == sessionId) {
      await _metaBox.delete(_activeSessionKey);
    }
  }

  @override
  Future<WorkoutSession?> getActiveSession() async {
    final activeId = _metaBox.get(_activeSessionKey);
    if (activeId == null) return null;
    return getSession(activeId);
  }
}
