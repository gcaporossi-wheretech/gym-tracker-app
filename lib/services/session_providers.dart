import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'providers.dart';

/// Tutte le sessioni ordinate per data (piu recenti prima).
/// autoDispose per ricaricare quando si torna al tab.
final allSessionsProvider = FutureProvider.autoDispose<List<WorkoutSession>>((ref) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return repo.getAllSessions();
});

/// Sessioni filtrate per periodo
enum SessionFilter { thisWeek, thisMonth, all }

final sessionFilterProvider = NotifierProvider<SessionFilterNotifier, SessionFilter>(() {
  return SessionFilterNotifier();
});

class SessionFilterNotifier extends Notifier<SessionFilter> {
  @override
  SessionFilter build() => SessionFilter.all;

  void set(SessionFilter filter) => state = filter;
}

final filteredSessionsProvider = FutureProvider.autoDispose<List<WorkoutSession>>((ref) async {
  final sessions = await ref.watch(allSessionsProvider.future);
  final filter = ref.watch(sessionFilterProvider);
  final now = DateTime.now();

  return switch (filter) {
    SessionFilter.thisWeek => () {
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
        return sessions.where((s) => s.date.isAfter(start)).toList();
      }(),
    SessionFilter.thisMonth => () {
        final start = DateTime(now.year, now.month, 1);
        return sessions.where((s) => s.date.isAfter(start)).toList();
      }(),
    SessionFilter.all => sessions,
  };
});
