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
}
