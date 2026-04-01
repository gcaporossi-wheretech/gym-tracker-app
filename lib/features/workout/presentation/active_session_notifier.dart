import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../models/models.dart';
import '../../../repositories/session_repository.dart';
import '../../../services/providers.dart';

const _uuid = Uuid();

/// State per la sessione di allenamento attiva
class ActiveSessionState {
  const ActiveSessionState({
    required this.session,
    this.currentExerciseIndex = 0,
    this.isCompleted = false,
  });

  final WorkoutSession session;
  final int currentExerciseIndex;
  final bool isCompleted;

  ExerciseLog? get currentExercise {
    if (currentExerciseIndex >= session.exercises.length) return null;
    return session.exercises[currentExerciseIndex];
  }

  int get totalExercises => session.exercises.length;
  int get completedExercises => session.exercises
      .where((e) => e.skipped || e.sets.every((s) => s.completed))
      .length;

  ActiveSessionState copyWith({
    WorkoutSession? session,
    int? currentExerciseIndex,
    bool? isCompleted,
  }) {
    return ActiveSessionState(
      session: session ?? this.session,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class ActiveSessionNotifier extends Notifier<ActiveSessionState?> {
  @override
  ActiveSessionState? build() => null;

  SessionRepository get _sessionRepo => ref.read(sessionRepositoryProvider);

  /// Avvia una nuova sessione dal DayPlan
  void startSession(DayPlan dayPlan) {
    final exercises = dayPlan.exercises.map((ep) {
      return ExerciseLog(
        exercisePlanId: ep.id,
        exerciseName: ep.name,
        muscleGroup: ep.muscleGroup,
        sets: List.generate(
          ep.sets,
          (i) => SetLog(setNumber: i + 1, plannedReps: ep.reps),
        ),
      );
    }).toList();

    final session = WorkoutSession(
      id: _uuid.v4(),
      date: DateTime.now(),
      dayPlanId: dayPlan.id,
      workoutName: dayPlan.name,
      exercises: exercises,
    );

    state = ActiveSessionState(session: session);
    _save();
  }

  /// Registra peso e rep per una serie
  void logSet({
    required int exerciseIndex,
    required int setIndex,
    required double weight,
    required int reps,
  }) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    final exercise = exercises[exerciseIndex];
    final sets = List<SetLog>.from(exercise.sets);

    sets[setIndex] = sets[setIndex].copyWith(
      weight: weight,
      actualReps: reps,
      completed: true,
    );
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
    );
    _save();
  }

  /// Salta un esercizio
  void skipExercise(int exerciseIndex) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    exercises[exerciseIndex] = exercises[exerciseIndex].copyWith(skipped: true);

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
    );
    _save();
  }

  /// Vai a un esercizio specifico
  void goToExercise(int index) {
    final s = state;
    if (s == null) return;
    if (index < 0 || index >= s.session.exercises.length) return;
    state = s.copyWith(currentExerciseIndex: index);
  }

  /// Completa la sessione
  void completeSession() {
    final s = state;
    if (s == null) return;

    final duration = DateTime.now().difference(s.session.date).inMinutes;
    state = s.copyWith(
      session: s.session.copyWith(completed: true, durationMinutes: duration),
      isCompleted: true,
    );
    _save();
  }

  /// Chiudi la sessione
  void closeSession() {
    state = null;
  }

  Future<void> _save() async {
    final s = state;
    if (s == null) return;
    await _sessionRepo.saveSession(s.session);
  }
}

/// Provider per la sessione attiva
final activeSessionProvider =
    NotifierProvider<ActiveSessionNotifier, ActiveSessionState?>(() {
  return ActiveSessionNotifier();
});
