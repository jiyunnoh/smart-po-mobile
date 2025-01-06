import '../constants/enum.dart';
import '../ui/common/constants.dart';

class Utility {
  static (double scoreChange, ChangeDirection scoreDiff) compareScore(
      double curScore, double prevScore,
      {double negScoreDiffThreshold = -scoreDiffThreshold,
      double posScoreDiffThreshold = scoreDiffThreshold,
      bool isSigDiff = false,
      bool shouldReverse = false}) {
    double target = (curScore - prevScore) / prevScore;
    double scoreChange = curScore - prevScore;

    if (shouldReverse) {
      scoreChange *= -1;
    }

    // If it is sig diff, compare raw score, not the percentage
    if (isSigDiff) {
      target = curScore;
      negScoreDiffThreshold = prevScore - negScoreDiffThreshold;
      posScoreDiffThreshold = prevScore + posScoreDiffThreshold;
    }

    if (target >= negScoreDiffThreshold && target <= posScoreDiffThreshold) {
      return (scoreChange, ChangeDirection.stable);
    }
    if (target > posScoreDiffThreshold) {
      return (
        scoreChange,
        isSigDiff
            ? shouldReverse
                ? ChangeDirection.sigNegative
                : ChangeDirection.sigPositive
            : shouldReverse
                ? ChangeDirection.negative
                : ChangeDirection.positive
      );
    }
    return (
      scoreChange,
      isSigDiff
          ? shouldReverse
              ? ChangeDirection.sigPositive
              : ChangeDirection.sigNegative
          : shouldReverse
              ? ChangeDirection.positive
              : ChangeDirection.negative
    );
  }
}
