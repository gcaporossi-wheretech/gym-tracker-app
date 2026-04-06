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
    this.warmupChecked = const [],
  });

  final WorkoutSession session;
  final int currentExerciseIndex;
  final bool isCompleted;
  final List<bool> warmupChecked;

  ExerciseLog? get currentExercise {
    if (currentExerciseIndex >= session.exercises.length) return null;
    return session.exercises[currentExerciseIndex];
  }

  int get totalExercises => session.exercises.length;
  int get completedExercises => session.exercises
      .where((e) => e.skipped || e.sets.every((s) => s.completed))
      .length;

  bool get warmupAllDone =>
      warmupChecked.isNotEmpty && warmupChecked.every((c) => c);
  int get warmupDoneCount => warmupChecked.where((c) => c).length;

  ActiveSessionState copyWith({
    WorkoutSession? session,
    int? currentExerciseIndex,
    bool? isCompleted,
    List<bool>? warmupChecked,
  }) {
    return ActiveSessionState(
      session: session ?? this.session,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      warmupChecked: warmupChecked ?? this.warmupChecked,
    );
  }
}

class ActiveSessionNotifier extends Notifier<ActiveSessionState?> {
  @override
  ActiveSessionState? build() => null;

  SessionRepository get _sessionRepo => ref.read(sessionRepositoryProvider);

  /// Avvia una nuova sessione dal DayPlan, con pre-fill pesi dall'ultima volta (GYM-23)
  Future<void> startSession(DayPlan dayPlan) async {
    // Cerca l'ultima sessione per questo workout
    final allSessions = await _sessionRepo.getAllSessions();
    final lastSession = allSessions
        .where((s) => s.dayPlanId == dayPlan.id && s.completed)
        .toList();
    final previous = lastSession.isNotEmpty ? lastSession.first : null;
    final exercises = dayPlan.exercises.map((ep) {
      // Find previous weights for this exercise (GYM-23)
      ExerciseLog? prevExercise;
      if (previous != null) {
        final matches = previous.exercises.where((e) => e.exercisePlanId == ep.id);
        if (matches.isNotEmpty) prevExercise = matches.first;
      }

      return ExerciseLog(
        exercisePlanId: ep.id,
        exerciseName: ep.name,
        muscleGroup: ep.muscleGroup,
        sets: List.generate(ep.sets, (i) {
          // Pre-fill weight from last session's corresponding set
          double prefillWeight = ep.suggestedWeight;
          if (prevExercise != null && i < prevExercise.sets.length) {
            final prevSet = prevExercise.sets[i];
            if (prevSet.completed && prevSet.weight > 0) {
              prefillWeight = prevSet.weight;
            }
          } else if (prevExercise != null && prevExercise.sets.isNotEmpty) {
            // Use last available set weight
            final lastCompleted = prevExercise.sets.where((s) => s.completed && s.weight > 0);
            if (lastCompleted.isNotEmpty) prefillWeight = lastCompleted.last.weight;
          }
          return SetLog(
            setNumber: i + 1,
            plannedReps: ep.reps,
            weight: prefillWeight,
          );
        }),
      );
    }).toList();

    final session = WorkoutSession(
      id: _uuid.v4(),
      date: DateTime.now(),
      dayPlanId: dayPlan.id,
      workoutName: dayPlan.name,
      exercises: exercises,
    );

    state = ActiveSessionState(
      session: session,
      warmupChecked: List.filled(dayPlan.warmup.length, false),
    );
    _save();
  }

  /// Riprendi una sessione esistente dallo storico (GYM-33)
  void resumeSession(WorkoutSession session, {int warmupCount = 0}) {
    final reopened = session.copyWith(completed: false);
    state = ActiveSessionState(
      session: reopened,
      warmupChecked: List.filled(warmupCount, true), // assume warmup was done
    );
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

  /// Riattiva un esercizio skippato
  void unskipExercise(int exerciseIndex) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    exercises[exerciseIndex] = exercises[exerciseIndex].copyWith(skipped: false);

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

  /// Toggle un item del riscaldamento (GYM-29)
  void toggleWarmup(int index) {
    final s = state;
    if (s == null) return;
    if (index < 0 || index >= s.warmupChecked.length) return;

    final updated = List<bool>.from(s.warmupChecked);
    updated[index] = !updated[index];
    state = s.copyWith(warmupChecked: updated);
  }

  /// Sposta un esercizio da una posizione a un'altra (GYM-27)
  void moveExercise(int fromIndex, int toIndex) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    final item = exercises.removeAt(fromIndex);
    exercises.insert(toIndex, item);

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
      currentExerciseIndex: toIndex,
    );
    _save();
  }

  /// Aggiunge un esercizio personalizzato alla sessione (GYM-26)
  void addCustomExercise({
    required String name,
    required int sets,
    required int reps,
    String muscleGroup = 'other',
    String exerciseType = 'weighted',
  }) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    exercises.add(ExerciseLog(
      exercisePlanId: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      exerciseName: name,
      muscleGroup: muscleGroup,
      sets: List.generate(sets, (i) => SetLog(setNumber: i + 1, plannedReps: reps)),
    ));

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
    );
    _save();
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

  /// Undo: segna serie come non completata
  void undoSet({required int exerciseIndex, required int setIndex}) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    final exercise = exercises[exerciseIndex];
    final sets = List<SetLog>.from(exercise.sets);

    sets[setIndex] = sets[setIndex].copyWith(completed: false);
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
    );
    _save();
  }

  /// Rimuove una serie da un esercizio (solo per questa sessione)
  void removeSet({required int exerciseIndex, required int setIndex}) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    final exercise = exercises[exerciseIndex];
    final sets = List<SetLog>.from(exercise.sets);

    if (sets.length <= 1) return; // almeno 1 serie
    sets.removeAt(setIndex);
    // Rinumera
    for (var i = 0; i < sets.length; i++) {
      sets[i] = sets[i].copyWith(setNumber: i + 1);
    }
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
    );
    _save();
  }

  /// Aggiunge una serie copiando i valori dell'ultima
  void addSet({required int exerciseIndex}) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    final exercise = exercises[exerciseIndex];
    final sets = List<SetLog>.from(exercise.sets);

    final lastSet = sets.last;
    sets.add(SetLog(
      setNumber: sets.length + 1,
      plannedReps: lastSet.plannedReps,
    ));
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
    );
    _save();
  }

  /// Applica peso a tutte le serie non completate di un esercizio
  void applyWeightToAll({required int exerciseIndex, required double weight}) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    final exercise = exercises[exerciseIndex];
    final sets = List<SetLog>.from(exercise.sets);

    for (var i = 0; i < sets.length; i++) {
      if (!sets[i].completed) {
        sets[i] = sets[i].copyWith(weight: weight);
      }
    }
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
    );
    _save();
  }

  /// Applica reps a tutte le serie non completate di un esercizio
  void applyRepsToAll({required int exerciseIndex, required int reps}) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    final exercise = exercises[exerciseIndex];
    final sets = List<SetLog>.from(exercise.sets);

    for (var i = 0; i < sets.length; i++) {
      if (!sets[i].completed) {
        sets[i] = sets[i].copyWith(plannedReps: reps);
      }
    }
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
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
