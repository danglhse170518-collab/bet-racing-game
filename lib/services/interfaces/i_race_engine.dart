import '../../models/bet_model.dart';
import '../../models/race_result_model.dart';

abstract class IRaceEngine {
  List<Duration> calculateDurations({
    required int racerCount,
    required int baseDurationSeconds,
  });

  RaceResult calculateResult({
    required List<BetItem> bets,
    required int winnerId,
    required int currentBalance,
  });
}