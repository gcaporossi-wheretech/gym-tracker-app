import 'package:freezed_annotation/freezed_annotation.dart';

part 'phase.freezed.dart';
part 'phase.g.dart';

@freezed
class Phase with _$Phase {
  const factory Phase({
    required int number, // 1, 2, 3
    required String name, // es. "Costruire le Fondamenta"
    required int weekStart, // 1, 5, 9
    required int weekEnd, // 4, 8, 12
    @Default('') String description,
    @Default(4) int deloadWeek, // settimana di deload (relativa alla fase)
  }) = _Phase;

  factory Phase.fromJson(Map<String, dynamic> json) => _$PhaseFromJson(json);
}
