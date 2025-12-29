// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Gym Tracker App';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get discard => 'Discard';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get send => 'Send';

  @override
  String get guest => 'Guest';

  @override
  String get getStarted => 'Get Started';

  @override
  String get continueAction => 'Continue';

  @override
  String get onboardingTitle => 'Enter your weight for personalization';

  @override
  String get loginTitle => 'Log in to your account';

  @override
  String get registerTitle => 'Create an account';

  @override
  String get registerAction => 'Register';

  @override
  String get loginAction => 'Log In';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get alreadyHaveAccount => 'Already have account?';

  @override
  String get googleButton => 'Google';

  @override
  String get verifyEmailTitle => 'Verify Email';

  @override
  String get verifyEmailMessage =>
      'A verification email has been sent to your email address. Please follow the link in the email.';

  @override
  String get resendEmail => 'Resend Email';

  @override
  String get cancelLogout => 'Cancel (Logout)';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordInstruction =>
      'Enter your email. We will send you a link to reset your password.';

  @override
  String get resetPasswordEmailSent =>
      'Password reset email sent! Check your inbox.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Enter email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Enter password again';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Enter name';

  @override
  String get weightLabel => 'Weight';

  @override
  String get errEmailRequired => 'Email required';

  @override
  String get errInvalidEmail => 'Invalid email';

  @override
  String get errPasswordRequired => 'Password required';

  @override
  String get errPasswordShort => 'Password must be at least 6 chars';

  @override
  String get errPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get errNameRequired => 'Name required';

  @override
  String get errNameShort => 'Name too short';

  @override
  String get errWeightRequired => 'Enter correct weight';

  @override
  String get errWeightInvalid => 'Weight must be a number > 0';

  @override
  String get errGoogleSignIn => 'Google Sign-In error';

  @override
  String get errInvalidCredentials => 'Invalid email or password';

  @override
  String get errLoginGeneral => 'Login error';

  @override
  String get errUserNotFound => 'User with this email not found';

  @override
  String get errWrongPassword => 'Wrong password';

  @override
  String get errEmailAlreadyInUse => 'The email address is already in use';

  @override
  String get errWeakPassword => 'Password is too weak';

  @override
  String get errTooManyRequests => 'Too many requests. Try again later';

  @override
  String get errRequiresRecentLogin =>
      'This action requires you to log in again';

  @override
  String get errUnknown => 'An unknown error occurred';

  @override
  String saveError(String error) {
    return 'Error saving: $error';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navJournal => 'Journal';

  @override
  String get navHistory => 'History';

  @override
  String get navStats => 'Statistics';

  @override
  String get navProfile => 'Profile';

  @override
  String get calendarTitle => 'Workout Calendar';

  @override
  String get selectDay => 'Select a day';

  @override
  String get selectMonth => 'Select month';

  @override
  String get pickMonthYear => 'Pick month and year';

  @override
  String get prevYear => 'Previous year';

  @override
  String get nextYear => 'Next year';

  @override
  String get backToToday => 'Latest';

  @override
  String get exercisesFor => 'Exercises for';

  @override
  String get noExercisesToday => 'No exercises for this day';

  @override
  String get workoutTitle => 'Workout';

  @override
  String get startWorkout => 'Start Workout';

  @override
  String get continueWorkout => 'Continue Workout';

  @override
  String get workoutToday => 'Workout for Today';

  @override
  String get noWorkoutToday => 'No workout logged for today';

  @override
  String get saveChangesTitle => 'Save changes?';

  @override
  String get unsavedChangesMsg => 'You have unsaved changes. Save before exit?';

  @override
  String get synchronized => 'Synchronized';

  @override
  String get selectWorkoutType => 'Select the type of training';

  @override
  String get splitPush => 'Push';

  @override
  String get splitPull => 'Pull';

  @override
  String get splitLegs => 'Legs';

  @override
  String get splitUpper => 'Upper Body';

  @override
  String get splitLower => 'Lower Body';

  @override
  String get splitFullBody => 'Full Body';

  @override
  String get splitCardio => 'Cardio';

  @override
  String get splitCustom => 'Custom';

  @override
  String get addExerciseBtn => 'Add Exercise';

  @override
  String get addSetBtn => 'Add Set';

  @override
  String get setsLabel => 'Sets';

  @override
  String get weightRepsLabel => 'Weight (kg·reps)';

  @override
  String get setLabelCompact => 'Set';

  @override
  String setNumber(int number) {
    return 'Set $number';
  }

  @override
  String deleteSet(int number) {
    return 'Delete set $number';
  }

  @override
  String setsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets',
      one: '1 set',
    );
    return '$_temp0';
  }

  @override
  String exercisesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String get weightUnit => 'kg';

  @override
  String get weightUnitHint => 'Kg';

  @override
  String get repsUnit => 'reps';

  @override
  String get repsUnitHint => 'Reps';

  @override
  String get calories => 'Calories';

  @override
  String caloriesCount(String count) {
    return '$count kcal';
  }

  @override
  String get exerciseDefaultName => 'Exercise';

  @override
  String get enterCustomExerciseName => 'Enter custom exercise name';

  @override
  String get exerciseNameHint => 'Exercise name';

  @override
  String get addExercise => 'Add exercise';

  @override
  String get addExercisesHint => 'Add exercises in calendar to see the graph';

  @override
  String get selectExercise => 'Select exercise';

  @override
  String get deleteExercise => 'Delete exercise';

  @override
  String get searchExercise => 'Search exercise';

  @override
  String get enterCustomName => 'Enter custom name';

  @override
  String get addExerciseTooltip => 'Add exercise';

  @override
  String get editExercisesTooltip => 'Edit exercises';

  @override
  String get chartsTitle => 'Progress — Charts';

  @override
  String get yourProgressFor => 'Your progress for';

  @override
  String get progressTooltip => 'Progress';

  @override
  String get exerciseLabel => 'Exercise:';

  @override
  String get chooseExercise => 'Choose exercise';

  @override
  String get tabMonth => 'Month';

  @override
  String get tabYear => 'Year';

  @override
  String get noDataRange => 'No data for selected exercise in this range';

  @override
  String get liftedWeight => 'Lifted volume';

  @override
  String get liftedWeightHelp => 'Volume = Weight × Reps';

  @override
  String get liftedWeightDescription => 'Formula description';

  @override
  String get totalLifted => 'Total lifted:';

  @override
  String get maxWeight => 'Max weight:';

  @override
  String get pointsCount => 'Points:';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get appLanguage => 'App Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageUk => 'Українська';

  @override
  String get languageEn => 'English';

  @override
  String get aboutApp => 'About App';

  @override
  String get appDescription => 'App for tracking your workouts.';

  @override
  String get delPhoto => 'Delete photo';

  @override
  String get deletePhotoTitle => 'Delete photo';

  @override
  String get deletePhotoConfirm => 'Do you really want to delete the photo?';

  @override
  String get logoutAction => 'Log Out';

  @override
  String get logoutTitle => 'Log out from profile';

  @override
  String get logoutConfirm => 'Do you really want to log out?';

  @override
  String get clearData => 'Clear all data';

  @override
  String get clearDataConfirmTitle => 'Clear all data';

  @override
  String get clearDataConfirmContent =>
      'This will delete all saved workouts and settings. Continue?';

  @override
  String get dataClearedSuccess => 'Data cleared successfully';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountTitle => 'Delete Account?';

  @override
  String get deleteAccountWarning =>
      'This action cannot be undone. All your data (workouts, stats, profile) will be permanently lost.';

  @override
  String get securityUpdate => 'Security Update';

  @override
  String get reLoginRequiredMsg =>
      'For security reasons, please Log Out and Log In again before deleting your account.';

  @override
  String get exSquat => 'Squat';

  @override
  String get exLunge => 'Lunge';

  @override
  String get exLegPress => 'Leg Press';

  @override
  String get exWallSit => 'Wall Sit';

  @override
  String get exLegExtension => 'Leg Extension';

  @override
  String get exLegCurl => 'Leg Curl';

  @override
  String get exDeadlift => 'Deadlift';

  @override
  String get exGoodMorning => 'Good Morning';

  @override
  String get exStandingCalfRaise => 'Standing Calf Raise';

  @override
  String get exSeatedCalfRaise => 'Seated Calf Raise';

  @override
  String get exPushUp => 'Push-up';

  @override
  String get exPullUp => 'Pull-up';

  @override
  String get exDip => 'Dip';

  @override
  String get exBenchPress => 'Bench Press';

  @override
  String get exMachineFly => 'Machine Fly';

  @override
  String get exLateralRaise => 'Lateral Raise';

  @override
  String get exBentOverRow => 'Bent Over Row';

  @override
  String get exLatPullDown => 'Lat Pull-down';

  @override
  String get exShoulderShrug => 'Shoulder Shrug';

  @override
  String get exOverheadPress => 'Overhead Press';

  @override
  String get exFrontRaise => 'Front Raise';

  @override
  String get exRearDeltRaise => 'Rear Delt Raise';

  @override
  String get exUprightRow => 'Upright Row';

  @override
  String get exFacePull => 'Face Pull';

  @override
  String get exBicepsCurl => 'Biceps Curl';

  @override
  String get exTricepsExtension => 'Triceps Extension';

  @override
  String get exCrunch => 'Crunch';

  @override
  String get exSitUp => 'Sit-up';

  @override
  String get exPlank => 'Plank';

  @override
  String get exLegRaise => 'Leg Raise';

  @override
  String get exHyperextension => 'Hyperextension';

  @override
  String get exHammerCurl => 'Hammer Curl';

  @override
  String get exZottmanCurl => 'Zottman Curl';

  @override
  String get exMachineRow => 'Machine Row';

  @override
  String get exLegRaiseHang => 'Hanging Leg Raise';
}
