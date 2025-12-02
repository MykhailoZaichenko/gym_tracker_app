import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'Gym Tracker App'**
  String get appName;

  /// Welcome page button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Onboarding page button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Onboarding page title
  ///
  /// In en, this message translates to:
  /// **'Enter your weight for personalization'**
  String get onboardingTitle;

  /// Header for stats card
  ///
  /// In en, this message translates to:
  /// **'Your progress for'**
  String get yourProgressFor;

  /// Sets count label
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get setsLabel;

  /// Weight/Reps count label
  ///
  /// In en, this message translates to:
  /// **'Weight (kg·reps)'**
  String get weightRepsLabel;

  /// Calories label
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// Snackbar for successful plan save
  ///
  /// In en, this message translates to:
  /// **'Plan saved successfully'**
  String get planSavedSuccess;

  /// Workout plan editor page title
  ///
  /// In en, this message translates to:
  /// **'Edit Plan'**
  String get editPlanTitle;

  /// Tooltip for save plan button
  ///
  /// In en, this message translates to:
  /// **'Save plan'**
  String get savePlanTooltip;

  /// Default user name
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Discard button
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Yes button
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Login page title
  ///
  /// In en, this message translates to:
  /// **'Log in to your account'**
  String get loginTitle;

  /// Register page title
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get registerTitle;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAction;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginAction;

  /// Forgot password button
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// Text on register page
  ///
  /// In en, this message translates to:
  /// **'Already have account?'**
  String get alreadyHaveAccount;

  /// Dialog title for custom exercise
  ///
  /// In en, this message translates to:
  /// **'Enter custom exercise name'**
  String get enterCustomExerciseName;

  /// Hint for custom exercise input
  ///
  /// In en, this message translates to:
  /// **'Exercise name'**
  String get exerciseNameHint;

  /// Button to add an exercise to a plan
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get addExercise;

  /// Empty graph state
  ///
  /// In en, this message translates to:
  /// **'Add exercises in calendar to see the graph'**
  String get addExercisesHint;

  /// Exercise selection hint
  ///
  /// In en, this message translates to:
  /// **'Select exercise'**
  String get selectExercise;

  /// Delete exercise button
  ///
  /// In en, this message translates to:
  /// **'Delete exercise'**
  String get deleteExercise;

  /// Search exercise hint
  ///
  /// In en, this message translates to:
  /// **'Search exercise'**
  String get searchExercise;

  /// Custom name option in exercise picker
  ///
  /// In en, this message translates to:
  /// **'Enter custom name'**
  String get enterCustomName;

  /// Email input label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Email input hint
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get emailHint;

  /// Password input label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Password input hint
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get passwordHint;

  /// Confirm password label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// Confirm password hint
  ///
  /// In en, this message translates to:
  /// **'Enter password again'**
  String get confirmPasswordHint;

  /// Name input label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// Name input hint
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get nameHint;

  /// Error: email empty
  ///
  /// In en, this message translates to:
  /// **'Email required'**
  String get errEmailRequired;

  /// Error: email invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get errInvalidEmail;

  /// Error: password empty
  ///
  /// In en, this message translates to:
  /// **'Password required'**
  String get errPasswordRequired;

  /// Error: password too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 chars'**
  String get errPasswordShort;

  /// Error: passwords mismatch
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errPasswordsDoNotMatch;

  /// Error: name empty
  ///
  /// In en, this message translates to:
  /// **'Name required'**
  String get errNameRequired;

  /// Error: name too short
  ///
  /// In en, this message translates to:
  /// **'Name too short'**
  String get errNameShort;

  /// Error: weight validation
  ///
  /// In en, this message translates to:
  /// **'Enter correct weight'**
  String get errWeightRequired;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Workout Calendar'**
  String get calendarTitle;

  /// Analytics button tooltip
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTooltip;

  /// Workout plan button
  ///
  /// In en, this message translates to:
  /// **'My Plan'**
  String get myPlan;

  /// Edit button tooltip
  ///
  /// In en, this message translates to:
  /// **'Edit exercises'**
  String get editExercisesTooltip;

  /// Add exercise FAB tooltip
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get addExerciseTooltip;

  /// Placeholder when no day selected
  ///
  /// In en, this message translates to:
  /// **'Select a day'**
  String get selectDay;

  /// Select month button label
  ///
  /// In en, this message translates to:
  /// **'Select month'**
  String get selectMonth;

  /// Header for exercise list
  ///
  /// In en, this message translates to:
  /// **'Exercises for'**
  String get exercisesFor;

  /// Empty state for day
  ///
  /// In en, this message translates to:
  /// **'No exercises for this day'**
  String get noExercisesToday;

  /// Fallback name
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exerciseDefaultName;

  /// Label for a single set line in compact view
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get setLabelCompact;

  /// Weight unit abbreviation
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get weightUnit;

  /// Weight input hint
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get weightUnitHint;

  /// Repetitions unit abbreviation
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get repsUnit;

  /// Repetitions input hint
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get repsUnitHint;

  /// Set count plural
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 set} other{{count} sets}}'**
  String setsCount(int count);

  /// Delete set menu item
  ///
  /// In en, this message translates to:
  /// **'Delete set {number}'**
  String deleteSet(int number);

  /// Set number label
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String setNumber(int number);

  /// Calories count format
  ///
  /// In en, this message translates to:
  /// **'{count} kcal'**
  String caloriesCount(String count);

  /// Graf page title
  ///
  /// In en, this message translates to:
  /// **'Progress — Charts'**
  String get chartsTitle;

  /// Dropdown label
  ///
  /// In en, this message translates to:
  /// **'Exercise:'**
  String get exerciseLabel;

  /// Dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Choose exercise'**
  String get chooseExercise;

  /// Tab label
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get tabMonth;

  /// Tab label
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get tabYear;

  /// Empty graph state range
  ///
  /// In en, this message translates to:
  /// **'No data for selected exercise in this range'**
  String get noDataRange;

  /// Legend label
  ///
  /// In en, this message translates to:
  /// **'Lifted weight'**
  String get liftedWeight;

  /// Summary label
  ///
  /// In en, this message translates to:
  /// **'Total lifted:'**
  String get totalLifted;

  /// Summary label
  ///
  /// In en, this message translates to:
  /// **'Points:'**
  String get pointsCount;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Dark mode switch
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light mode switch
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Notifications switch
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Clear data button
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get clearData;

  /// Dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get clearDataConfirmTitle;

  /// Dialog content
  ///
  /// In en, this message translates to:
  /// **'This will delete all saved workouts and settings. Continue?'**
  String get clearDataConfirmContent;

  /// Success snackbar
  ///
  /// In en, this message translates to:
  /// **'Data cleared successfully'**
  String get dataClearedSuccess;

  /// About button
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// About dialog content
  ///
  /// In en, this message translates to:
  /// **'App for tracking your workouts.'**
  String get appDescription;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// Ukrainian language name
  ///
  /// In en, this message translates to:
  /// **'Українська'**
  String get languageUk;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// Language selector title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutAction;

  /// Logout dialog title
  ///
  /// In en, this message translates to:
  /// **'Log out from profile'**
  String get logoutTitle;

  /// Logout dialog content
  ///
  /// In en, this message translates to:
  /// **'Do you really want to log out?'**
  String get logoutConfirm;

  /// Edit profile page title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// Weight input label
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// Weight validation error
  ///
  /// In en, this message translates to:
  /// **'Weight must be a number > 0'**
  String get errWeightInvalid;

  /// Dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete photo'**
  String get deletePhotoTitle;

  /// Dialog content
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete the photo?'**
  String get deletePhotoConfirm;

  /// Save error message
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String saveError(String error);

  /// Used in plan editor dialog, e.g. 'on Monday'
  ///
  /// In en, this message translates to:
  /// **'on {day}'**
  String onDay(String day);

  /// Workout page title
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workoutTitle;

  /// Month picker title
  ///
  /// In en, this message translates to:
  /// **'Pick month and year'**
  String get pickMonthYear;

  /// Tooltip for previous year
  ///
  /// In en, this message translates to:
  /// **'Previous year'**
  String get prevYear;

  /// Tooltip for next year
  ///
  /// In en, this message translates to:
  /// **'Next year'**
  String get nextYear;

  /// Pop save dialog title
  ///
  /// In en, this message translates to:
  /// **'Save changes?'**
  String get saveChangesTitle;

  /// Pop save dialog content
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Save before exit?'**
  String get unsavedChangesMsg;

  /// Navbar home label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Button to return to today's date
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get backToToday;

  /// Navbar profile label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Squat'**
  String get exSquat;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Lunge'**
  String get exLunge;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Leg Press'**
  String get exLegPress;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Wall Sit'**
  String get exWallSit;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Leg Extension'**
  String get exLegExtension;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Leg Curl'**
  String get exLegCurl;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Deadlift'**
  String get exDeadlift;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get exGoodMorning;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Standing Calf Raise'**
  String get exStandingCalfRaise;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Seated Calf Raise'**
  String get exSeatedCalfRaise;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Push-up'**
  String get exPushUp;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Pull-up'**
  String get exPullUp;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Dip'**
  String get exDip;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Bench Press'**
  String get exBenchPress;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Machine Fly'**
  String get exMachineFly;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Lateral Raise'**
  String get exLateralRaise;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Bent Over Row'**
  String get exBentOverRow;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Lat Pull-down'**
  String get exLatPullDown;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Shoulder Shrug'**
  String get exShoulderShrug;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Overhead Press'**
  String get exOverheadPress;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Front Raise'**
  String get exFrontRaise;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Rear Delt Raise'**
  String get exRearDeltRaise;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Upright Row'**
  String get exUprightRow;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Face Pull'**
  String get exFacePull;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Biceps Curl'**
  String get exBicepsCurl;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Triceps Extension'**
  String get exTricepsExtension;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Crunch'**
  String get exCrunch;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Sit-up'**
  String get exSitUp;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Plank'**
  String get exPlank;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Leg Raise'**
  String get exLegRaise;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Hyperextension'**
  String get exHyperextension;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Hammer Curl'**
  String get exHammerCurl;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Zottman Curl'**
  String get exZottmanCurl;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Machine Row'**
  String get exMachineRow;

  /// Exercise name
  ///
  /// In en, this message translates to:
  /// **'Hanging Leg Raise'**
  String get exLegRaiseHang;

  /// Title for plan proposal dialog
  ///
  /// In en, this message translates to:
  /// **'Create your workout plan!'**
  String get proposalTitle;

  /// Content for plan proposal dialog
  ///
  /// In en, this message translates to:
  /// **'To get the best results, create a weekly schedule. We will remind you about your workouts.'**
  String get proposalSubtitle;

  /// Button to navigate to plan editor
  ///
  /// In en, this message translates to:
  /// **'Go to Plan'**
  String get goToPlan;

  /// Button to close proposal dialog
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get maybeLater;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
