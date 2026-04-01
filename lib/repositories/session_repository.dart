import '../models/workout_session.dart';

/// Repository astratto per la gestione delle sessioni di allenamento
abstract class SessionRepository {
  Future<List<WorkoutSession>> getAllSessions();
  Future<List<WorkoutSession>> getSessionsInRange(DateTime from, DateTime to);
  Future<WorkoutSession?> getSession(String sessionId);
  Future<void> saveSession(WorkoutSession session);
  Future<void> deleteSession(String sessionId);
  Future<WorkoutSession?> getActiveSession();
}
