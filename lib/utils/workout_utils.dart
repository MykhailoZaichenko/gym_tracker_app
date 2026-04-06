import 'package:gym_tracker_app/data/seed/exercise_catalog.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class WorkoutUtils {
  static String getLocalizedType(String key, AppLocalizations loc) {
    switch (key) {
      case 'push':
        return loc.splitPush;
      case 'pull':
        return loc.splitPull;
      case 'legs':
        return loc.splitLegs;
      case 'upper':
        return loc.splitUpper;
      case 'lower':
        return loc.splitLower;
      case 'full_body':
        return loc.splitFullBody;
      case 'cardio':
        return loc.splitCardio;
      case 'custom':
        return loc.splitCustom;
      default:
        return key.toUpperCase();
    }
  }

  static double calculateSetVolume({
    required ExerciseType type,
    required double userBodyWeight,
    double weight = 0.0,
    double reps = 0.0,
  }) {
    if (type == ExerciseType.cardio) {
      return 0.0;
    }
    if (type == ExerciseType.bodyweight) {
      return (userBodyWeight + weight) * reps;
    }
    return weight * reps;
  }
}
