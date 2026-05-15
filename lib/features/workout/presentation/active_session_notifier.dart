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
    // Auto-finalizza sessioni orfane (con tutti i set loggati ma completed=false)
    await _autoFinalizeOrphanSessions();

    // Cerca l'ultima sessione per questo workout
    final allSessions = await _sessionRepo.getAllSessions();
    // Consider both completed sessions AND sessions with at least one logged set.
    // This way pre-fill works even if the user forgot to "Completa Workout".
    bool hasUserData(WorkoutSession s) =>
        s.completed ||
        s.exercises.any((e) => e.sets.any((set) =>
            set.completed || set.weight > 0));
    final matchingSessions = allSessions
        .where((s) => s.dayPlanId == dayPlan.id && hasUserData(s))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first
    // Skip the current/active session itself if not completed
    final currentActive = state?.session.id;
    final previous = matchingSessions
        .where((s) => s.id != currentActive)
        .firstOrNull;
    final exercises = dayPlan.exercises.map((ep) {
      // Find previous exercise by ID, or by name as fallback (GYM-23)
      ExerciseLog? prevExercise;
      if (previous != null) {
        final byId = previous.exercises.where((e) => e.exercisePlanId == ep.id);
        if (byId.isNotEmpty) {
          prevExercise = byId.first;
        } else {
          final byName = previous.exercises.where((e) =>
              e.exerciseName.toLowerCase() == ep.name.toLowerCase());
          if (byName.isNotEmpty) prevExercise = byName.first;
        }
      }

      return ExerciseLog(
        exercisePlanId: ep.id,
        exerciseName: ep.name,
        muscleGroup: ep.muscleGroup,
        sets: List.generate(ep.sets, (i) {
          double prefillWeight = ep.suggestedWeight;
          int prefillReps = ep.reps;

          if (prevExercise != null) {
            bool hasData(SetLog s) => s.completed || s.weight > 0 || s.actualReps > 0;
            // Try the corresponding set index first
            SetLog? matchedSet;
            if (i < prevExercise.sets.length && hasData(prevExercise.sets[i])) {
              matchedSet = prevExercise.sets[i];
            }
            // Fallback: last set with data from previous session
            matchedSet ??= prevExercise.sets
                .where(hasData)
                .fold<SetLog?>(null, (prev, s) => s);

            if (matchedSet != null) {
              if (matchedSet.weight > 0) prefillWeight = matchedSet.weight;
              final repsValue = matchedSet.actualReps > 0
                  ? matchedSet.actualReps
                  : matchedSet.plannedReps;
              if (repsValue > 0) prefillReps = repsValue;
            }
          }

          return SetLog(
            setNumber: i + 1,
            plannedReps: prefillReps,
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

  /// Aggiorna peso/reps tipate dall'utente SENZA marcare la serie completata.
  /// Usato per persistere i valori che l'utente sta digitando, cosi non si
  /// perdono se chiude l'app o navigando.
  void updateSetTyped({
    required int exerciseIndex,
    required int setIndex,
    double? weight,
    int? reps,
  }) {
    final s = state;
    if (s == null) return;
    if (exerciseIndex < 0 || exerciseIndex >= s.session.exercises.length) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    final exercise = exercises[exerciseIndex];
    if (setIndex < 0 || setIndex >= exercise.sets.length) return;

    final sets = List<SetLog>.from(exercise.sets);
    final current = sets[setIndex];
    if (current.completed) return; // non toccare serie completate

    sets[setIndex] = current.copyWith(
      weight: weight ?? current.weight,
      plannedReps: reps ?? current.plannedReps,
    );
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
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

  /// Aggiunge un esercizio personalizzato alla sessione (GYM-26, GYM-34)
  void addCustomExercise({
    required String name,
    required int sets,
    required int reps,
    String muscleGroup = 'other',
    String exerciseType = 'weighted',
    String notes = '',
  }) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    exercises.add(ExerciseLog(
      exercisePlanId: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      exerciseName: name,
      muscleGroup: muscleGroup,
      notes: notes,
      sets: List.generate(sets, (i) => SetLog(setNumber: i + 1, plannedReps: reps)),
    ));

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
    );
    _save();
  }

  /// Rimuove un esercizio dalla sessione
  void removeExercise(int exerciseIndex) {
    final s = state;
    if (s == null) return;

    final exercises = List<ExerciseLog>.from(s.session.exercises);
    if (exerciseIndex < 0 || exerciseIndex >= exercises.length) return;
    if (exercises.length <= 1) return; // almeno 1 esercizio

    exercises.removeAt(exerciseIndex);

    // Adjust currentExerciseIndex if needed
    var currentIdx = s.currentExerciseIndex;
    if (currentIdx >= exercises.length) {
      currentIdx = exercises.length - 1;
    }

    state = s.copyWith(
      session: s.session.copyWith(exercises: exercises),
      currentExerciseIndex: currentIdx,
    );
    _save();
  }

  /// Completa la sessione
  void completeSession() {
    final s = state;
    if (s == null) return;

    final duration = _computeDuration(s.session);
    state = s.copyWith(
      session: s.session.copyWith(completed: true, durationMinutes: duration),
      isCompleted: true,
    );
    _save();
  }

  /// Finalizza automaticamente sessioni che hanno tutte le serie loggate
  /// ma sono rimaste con completed=false (es. utente ha chiuso app senza
  /// premere "Completa Workout"). Si applica solo a sessioni > 1 ora fa.
  Future<void> _autoFinalizeOrphanSessions() async {
    final all = await _sessionRepo.getAllSessions();
    final cutoff = DateTime.now().subtract(const Duration(hours: 1));
    for (final s in all) {
      if (s.completed) continue;
      if (s.date.isAfter(cutoff)) continue; // troppo recente, potrebbe essere in corso
      // Tutti i set sono stati completati o l'esercizio e' skipped
      final allDone = s.exercises.every((e) =>
          e.skipped || (e.sets.isNotEmpty && e.sets.every((set) => set.completed)));
      if (!allDone) continue;
      final finalized = s.copyWith(
        completed: true,
        durationMinutes: _computeDuration(s),
      );
      await _sessionRepo.saveSession(finalized);
    }
  }

  /// Calcola la durata reale del workout, evitando i valori anomali quando
  /// l'utente lascia l'app aperta in background per ore (fix bug durate >24h).
  /// Se l'intervallo da session.date a now > 4h, stima dai set completati
  /// (~2 min/serie compresi recuperi).
  int _computeDuration(WorkoutSession session) {
    final elapsed = DateTime.now().difference(session.date).inMinutes;
    const maxReasonable = 240; // 4 ore
    if (elapsed <= maxReasonable && elapsed > 0) return elapsed;
    final completedSets = session.totalCompletedSets;
    if (completedSets == 0) return 60;
    return (completedSets * 2).clamp(45, 180);
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
      weight: lastSet.weight, // copy weight too
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
