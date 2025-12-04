import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

String getLocalizedFirebaseError(BuildContext context, Object error) {
  final loc = AppLocalizations.of(context)!;

  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'user-not-found':
        return loc.errUserNotFound;
      case 'wrong-password':
        return loc.errWrongPassword;
      case 'email-already-in-use':
        return loc.errEmailAlreadyInUse;
      case 'invalid-email':
        return loc.errInvalidEmail;
      case 'weak-password':
        return loc.errWeakPassword;
      case 'too-many-requests':
        return loc.errTooManyRequests;
      case 'requires-recent-login':
        return loc.errRequiresRecentLogin;
      default:
        return error.message ?? loc.errUnknown;
    }
  }
  return error.toString().replaceAll('Exception: ', '');
}
