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

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

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

  /// Saved confirmation
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

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

  /// Send Button
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Default user name
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

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

  /// Google Sign-In Button
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get googleButton;

  /// Verify Email Page Title
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmailTitle;

  /// Verify Email Page Message
  ///
  /// In en, this message translates to:
  /// **'A verification email has been sent to your email address. Please follow the link in the email.'**
  String get verifyEmailMessage;

  /// Resend Email Button
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// Cancel and Logout Button
  ///
  /// In en, this message translates to:
  /// **'Cancel (Logout)'**
  String get cancelLogout;

  /// Reset Password Dialog Title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// Reset Password Dialog Instruction
  ///
  /// In en, this message translates to:
  /// **'Enter your email. We will send you a link to reset your password.'**
  String get resetPasswordInstruction;

  /// Reset Password Email Sent Message
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent! Check your inbox.'**
  String get resetPasswordEmailSent;

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

  /// Weight input label
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// Repetitions label
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get repsLabel;

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

  /// Weight validation error
  ///
  /// In en, this message translates to:
  /// **'Weight must be a number > 0'**
  String get errWeightInvalid;

  /// Google Sign-In error message
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In error'**
  String get errGoogleSignIn;

  /// Invalid credentials error message
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get errInvalidCredentials;

  /// General login error message
  ///
  /// In en, this message translates to:
  /// **'Login error'**
  String get errLoginGeneral;

  /// User not found error message
  ///
  /// In en, this message translates to:
  /// **'User with this email not found'**
  String get errUserNotFound;

  /// Wrong password error message
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get errWrongPassword;

  /// Email already in use error message
  ///
  /// In en, this message translates to:
  /// **'The email address is already in use'**
  String get errEmailAlreadyInUse;

  /// Weak password error message
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get errWeakPassword;

  /// Too many requests error message
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Try again later'**
  String get errTooManyRequests;

  /// Requires recent login error message
  ///
  /// In en, this message translates to:
  /// **'This action requires you to log in again'**
  String get errRequiresRecentLogin;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get errUnknown;

  /// Save error message
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String saveError(String error);

  /// Navbar home label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Label for the first tab
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get navJournal;

  /// Label for the second tab
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// Label for the third tab
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get navStats;

  /// Navbar profile label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Workout Calendar'**
  String get calendarTitle;

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

  /// Button to return to today's date
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get backToToday;

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

  /// Workout page title
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workoutTitle;

  /// Text on the main button to begin a new workout session
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get startWorkout;

  /// Text on the main button to resume an existing workout session
  ///
  /// In en, this message translates to:
  /// **'Continue Workout'**
  String get continueWorkout;

  /// Title displayed on the dashboard card
  ///
  /// In en, this message translates to:
  /// **'Workout for Today'**
  String get workoutToday;

  /// Message displayed on the Journal tab when empty
  ///
  /// In en, this message translates to:
  /// **'No workout logged for today'**
  String get noWorkoutToday;

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

  /// Badge shown when internet connection is restored
  ///
  /// In en, this message translates to:
  /// **'Synchronized'**
  String get synchronized;

  /// Training type selection prompt
  ///
  /// In en, this message translates to:
  /// **'Select the type of training'**
  String get selectWorkoutType;

  /// Push split name
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get splitPush;

  /// Pull split name
  ///
  /// In en, this message translates to:
  /// **'Pull'**
  String get splitPull;

  /// Legs split name
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get splitLegs;

  /// Upper Body split name
  ///
  /// In en, this message translates to:
  /// **'Upper Body'**
  String get splitUpper;

  /// Lower Body split name
  ///
  /// In en, this message translates to:
  /// **'Lower Body'**
  String get splitLower;

  /// Full Body split name
  ///
  /// In en, this message translates to:
  /// **'Full Body'**
  String get splitFullBody;

  /// Cardio split name
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get splitCardio;

  /// Custom split name
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get splitCustom;

  /// Button to copy data from last workout of specific type
  ///
  /// In en, this message translates to:
  /// **'Copy previous {type} workout'**
  String copyPreviousWorkout(String type);

  /// Button label to add a new exercise
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExerciseBtn;

  /// Button label inside a specific exercise card
  ///
  /// In en, this message translates to:
  /// **'Add Set'**
  String get addSetBtn;

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

  /// Label for a single set line in compact view
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get setLabelCompact;

  /// Set number label
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String setNumber(int number);

  /// Delete set menu item
  ///
  /// In en, this message translates to:
  /// **'Delete set {number}'**
  String deleteSet(int number);

  /// Set count plural
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 set} other{{count} sets}}'**
  String setsCount(int count);

  /// Exercise count plural
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 exercise} other{{count} exercises}}'**
  String exercisesCount(int count);

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

  /// Calories label
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// Calories count format
  ///
  /// In en, this message translates to:
  /// **'{count} kcal'**
  String caloriesCount(String count);

  /// Fallback name
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exerciseDefaultName;

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

  /// Button to add an exercise
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

  /// Add exercise FAB tooltip
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get addExerciseTooltip;

  /// Edit button tooltip
  ///
  /// In en, this message translates to:
  /// **'Edit exercises'**
  String get editExercisesTooltip;

  /// Graf page title
  ///
  /// In en, this message translates to:
  /// **'Progress — Charts'**
  String get chartsTitle;

  /// Header for stats card
  ///
  /// In en, this message translates to:
  /// **'Your progress for'**
  String get yourProgressFor;

  /// Analytics button tooltip
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTooltip;

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
  /// **'Lifted volume'**
  String get liftedWeight;

  /// Tooltip text explaining the volume formula
  ///
  /// In en, this message translates to:
  /// **'Volume = Weight × Reps'**
  String get liftedWeightHelp;

  /// Semantics/Tooltip for the help button itself
  ///
  /// In en, this message translates to:
  /// **'Formula description'**
  String get liftedWeightDescription;

  /// Summary label
  ///
  /// In en, this message translates to:
  /// **'Total lifted:'**
  String get totalLifted;

  /// Summary label
  ///
  /// In en, this message translates to:
  /// **'Max weight:'**
  String get maxWeight;

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

  /// Edit profile page title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

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

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// Language selector title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

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

  /// Delete photo text
  ///
  /// In en, this message translates to:
  /// **'Delete photo'**
  String get delPhoto;

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

  /// Delete Account Button
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Delete Account Dialog Title
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountTitle;

  /// Delete Account Dialog Warning Message
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data (workouts, stats, profile) will be permanently lost.'**
  String get deleteAccountWarning;

  /// Security Update Title
  ///
  /// In en, this message translates to:
  /// **'Security Update'**
  String get securityUpdate;

  /// Re-login required message before account deletion
  ///
  /// In en, this message translates to:
  /// **'For security reasons, please Log Out and Log In again before deleting your account.'**
  String get reLoginRequiredMsg;

  /// Barbell squat
  ///
  /// In en, this message translates to:
  /// **'Squat'**
  String get exSquat;

  /// Barbell front squat
  ///
  /// In en, this message translates to:
  /// **'Front Squat'**
  String get exFrontSquat;

  /// Squat holding a dumbbell/kettlebell at chest
  ///
  /// In en, this message translates to:
  /// **'Goblet Squat'**
  String get exGobletSquat;

  /// Static lunge
  ///
  /// In en, this message translates to:
  /// **'Lunge'**
  String get exLunge;

  /// Lunges while moving forward
  ///
  /// In en, this message translates to:
  /// **'Walking Lunge'**
  String get exWalkingLunge;

  /// Single leg squat with rear foot elevated
  ///
  /// In en, this message translates to:
  /// **'Bulgarian Split Squat'**
  String get exBulgarianSplitSquat;

  /// Leg press machine
  ///
  /// In en, this message translates to:
  /// **'Leg Press'**
  String get exLegPress;

  /// Static wall sit exercise
  ///
  /// In en, this message translates to:
  /// **'Wall Sit'**
  String get exWallSit;

  /// Leg extension machine
  ///
  /// In en, this message translates to:
  /// **'Leg Extension'**
  String get exLegExtension;

  /// Leg curl machine (seated or lying)
  ///
  /// In en, this message translates to:
  /// **'Leg Curl'**
  String get exLegCurl;

  /// Conventional deadlift
  ///
  /// In en, this message translates to:
  /// **'Deadlift'**
  String get exDeadlift;

  /// Deadlift with wide stance
  ///
  /// In en, this message translates to:
  /// **'Sumo Deadlift'**
  String get exSumoDeadlift;

  /// RDL - stiff leg deadlift variant
  ///
  /// In en, this message translates to:
  /// **'Romanian Deadlift'**
  String get exRomanianDeadlift;

  /// Barbell good morning exercise
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get exGoodMorning;

  /// Barbell hip thrust
  ///
  /// In en, this message translates to:
  /// **'Hip Thrust'**
  String get exHipThrust;

  /// Bodyweight or weighted bridge on floor
  ///
  /// In en, this message translates to:
  /// **'Glute Bridge'**
  String get exGluteBridge;

  /// Calf raise standing
  ///
  /// In en, this message translates to:
  /// **'Standing Calf Raise'**
  String get exStandingCalfRaise;

  /// Calf raise seated machine
  ///
  /// In en, this message translates to:
  /// **'Seated Calf Raise'**
  String get exSeatedCalfRaise;

  /// Bent over calf raise
  ///
  /// In en, this message translates to:
  /// **'Donkey Calf Raise'**
  String get exDonkeyCalfRaise;

  /// Legs pushing out machine
  ///
  /// In en, this message translates to:
  /// **'Abductor Machine'**
  String get exAbductorMachine;

  /// Legs squeezing in machine
  ///
  /// In en, this message translates to:
  /// **'Adductor Machine'**
  String get exAdductorMachine;

  /// Flat barbell bench press
  ///
  /// In en, this message translates to:
  /// **'Bench Press'**
  String get exBenchPress;

  /// Incline barbell bench press
  ///
  /// In en, this message translates to:
  /// **'Incline Bench Press'**
  String get exInclineBenchPress;

  /// Decline barbell bench press
  ///
  /// In en, this message translates to:
  /// **'Decline Bench Press'**
  String get exDeclineBenchPress;

  /// Flat dumbbell press
  ///
  /// In en, this message translates to:
  /// **'Dumbbell Bench Press'**
  String get exDumbbellBenchPress;

  /// Incline dumbbell press
  ///
  /// In en, this message translates to:
  /// **'Incline Dumbbell Press'**
  String get exInclineDumbbellPress;

  /// Standard push-up
  ///
  /// In en, this message translates to:
  /// **'Push-up'**
  String get exPushUp;

  /// Close grip push-up
  ///
  /// In en, this message translates to:
  /// **'Diamond Push-up'**
  String get exDiamondPushUp;

  /// Triceps/Chest dip on parallel bars
  ///
  /// In en, this message translates to:
  /// **'Dip'**
  String get exDip;

  /// Chest fly machine
  ///
  /// In en, this message translates to:
  /// **'Machine Fly (Pec Deck)'**
  String get exMachineFly;

  /// Standing cable fly
  ///
  /// In en, this message translates to:
  /// **'Cable Crossover'**
  String get exCableCrossover;

  /// Chest fly on bench
  ///
  /// In en, this message translates to:
  /// **'Dumbbell Fly'**
  String get exDumbbellFly;

  /// Dumbbell pullover on bench
  ///
  /// In en, this message translates to:
  /// **'Pullover'**
  String get exPullover;

  /// Seated chest press machine
  ///
  /// In en, this message translates to:
  /// **'Chest Press Machine'**
  String get exChestPressMachine;

  /// Overhand grip pull-up
  ///
  /// In en, this message translates to:
  /// **'Pull-up'**
  String get exPullUp;

  /// Underhand grip pull-up
  ///
  /// In en, this message translates to:
  /// **'Chin-up'**
  String get exChinUp;

  /// Cable lat pull-down
  ///
  /// In en, this message translates to:
  /// **'Lat Pull-Down'**
  String get exLatPullDown;

  /// Narrow grip pull-down
  ///
  /// In en, this message translates to:
  /// **'Close Grip Lat Pull-Down'**
  String get exCloseGripLatPullDown;

  /// Barbell row
  ///
  /// In en, this message translates to:
  /// **'Bent-Over Row'**
  String get exBentOverRow;

  /// Barbell row with underhand grip
  ///
  /// In en, this message translates to:
  /// **'Reverse Grip Row'**
  String get exReverseGripRow;

  /// One arm row on bench
  ///
  /// In en, this message translates to:
  /// **'Single Arm Dumbbell Row'**
  String get exSingleArmDumbbellRow;

  /// T-Bar row machine or landmine
  ///
  /// In en, this message translates to:
  /// **'T-Bar Row'**
  String get exTBarRow;

  /// Horizontal cable row
  ///
  /// In en, this message translates to:
  /// **'Seated Cable Row'**
  String get exSeatedCableRow;

  /// Seated row machine
  ///
  /// In en, this message translates to:
  /// **'Machine Row'**
  String get exMachineRow;

  /// Cable pulldown with straight arms
  ///
  /// In en, this message translates to:
  /// **'Straight-Arm Pulldown'**
  String get exStraightArmPulldown;

  /// Back extension bench
  ///
  /// In en, this message translates to:
  /// **'Hyperextension'**
  String get exHyperextension;

  /// Partial deadlift from rack
  ///
  /// In en, this message translates to:
  /// **'Rack Pull'**
  String get exRackPull;

  /// Standing barbell shoulder press (Military)
  ///
  /// In en, this message translates to:
  /// **'Overhead Press'**
  String get exOverheadPress;

  /// Shoulder press seated
  ///
  /// In en, this message translates to:
  /// **'Seated Dumbbell Press'**
  String get exSeatedDumbbellPress;

  /// Rotating dumbbell shoulder press
  ///
  /// In en, this message translates to:
  /// **'Arnold Press'**
  String get exArnoldPress;

  /// Dumbbell side raise
  ///
  /// In en, this message translates to:
  /// **'Lateral Raise'**
  String get exLateralRaise;

  /// Side raise using cable machine
  ///
  /// In en, this message translates to:
  /// **'Cable Lateral Raise'**
  String get exCableLateralRaise;

  /// Dumbbell front raise
  ///
  /// In en, this message translates to:
  /// **'Front Raise'**
  String get exFrontRaise;

  /// Bent over reverse fly
  ///
  /// In en, this message translates to:
  /// **'Rear Delt Raise'**
  String get exRearDeltRaise;

  /// Rear delt machine fly
  ///
  /// In en, this message translates to:
  /// **'Reverse Pec Deck'**
  String get exReversePecDeck;

  /// Cable pull towards face
  ///
  /// In en, this message translates to:
  /// **'Face Pull'**
  String get exFacePull;

  /// Barbell/Dumbbell pull to chin
  ///
  /// In en, this message translates to:
  /// **'Upright Row'**
  String get exUprightRow;

  /// Shoulder shrugs for traps
  ///
  /// In en, this message translates to:
  /// **'Shrug'**
  String get exShoulderShrug;

  /// Barbell curl
  ///
  /// In en, this message translates to:
  /// **'Biceps Curl'**
  String get exBicepsCurl;

  /// Standard dumbbell curl
  ///
  /// In en, this message translates to:
  /// **'Dumbbell Curl'**
  String get exDumbbellCurl;

  /// Neutral grip curl
  ///
  /// In en, this message translates to:
  /// **'Hammer Curl'**
  String get exHammerCurl;

  /// Curl on preacher bench
  ///
  /// In en, this message translates to:
  /// **'Preacher Curl'**
  String get exPreacherCurl;

  /// Seated single arm curl
  ///
  /// In en, this message translates to:
  /// **'Concentration Curl'**
  String get exConcentrationCurl;

  /// Bicep curl on cable machine
  ///
  /// In en, this message translates to:
  /// **'Cable Curl'**
  String get exCableCurl;

  /// Curl up, rotate, lower down
  ///
  /// In en, this message translates to:
  /// **'Zottman Curl'**
  String get exZottmanCurl;

  /// Dumbbell overhead extension
  ///
  /// In en, this message translates to:
  /// **'Overhead Triceps Extension'**
  String get exTricepsExtension;

  /// Lying triceps extension with barbell
  ///
  /// In en, this message translates to:
  /// **'Skull Crusher'**
  String get exSkullCrusher;

  /// Cable pushdown
  ///
  /// In en, this message translates to:
  /// **'Tricep Pushdown'**
  String get exTricepPushdown;

  /// Seated dip machine
  ///
  /// In en, this message translates to:
  /// **'Tricep Dip Machine'**
  String get exTricepDipMachine;

  /// Dip using a bench
  ///
  /// In en, this message translates to:
  /// **'Bench Dip'**
  String get exBenchDip;

  /// Standard floor crunch
  ///
  /// In en, this message translates to:
  /// **'Crunch'**
  String get exCrunch;

  /// Kneeling cable crunch
  ///
  /// In en, this message translates to:
  /// **'Cable Crunch'**
  String get exCableCrunch;

  /// Full sit-up
  ///
  /// In en, this message translates to:
  /// **'Sit-up'**
  String get exSitUp;

  /// Lying leg raise
  ///
  /// In en, this message translates to:
  /// **'Leg Raise'**
  String get exLegRaise;

  /// Leg raise hanging from bar
  ///
  /// In en, this message translates to:
  /// **'Hanging Leg Raise'**
  String get exLegRaiseHang;

  /// Seated torso twist
  ///
  /// In en, this message translates to:
  /// **'Russian Twist'**
  String get exRussianTwist;

  /// Static plank
  ///
  /// In en, this message translates to:
  /// **'Plank'**
  String get exPlank;

  /// Static side plank
  ///
  /// In en, this message translates to:
  /// **'Side Plank'**
  String get exSidePlank;

  /// Rollout with wheel
  ///
  /// In en, this message translates to:
  /// **'Ab Wheel Rollout'**
  String get exAbWheelRollout;

  /// Elbow to knee crunch
  ///
  /// In en, this message translates to:
  /// **'Bicycle Crunch'**
  String get exBicycleCrunch;

  /// Diagonal cable twist
  ///
  /// In en, this message translates to:
  /// **'Cable Woodchopper'**
  String get exWoodchopper;

  /// Running/Walking on treadmill
  ///
  /// In en, this message translates to:
  /// **'Treadmill'**
  String get exCardioTreadmill;

  /// Elliptical machine
  ///
  /// In en, this message translates to:
  /// **'Elliptical'**
  String get exCardioElliptical;

  /// Cardio rowing
  ///
  /// In en, this message translates to:
  /// **'Rowing Machine'**
  String get exCardioRowing;

  /// Walking with heavy weights
  ///
  /// In en, this message translates to:
  /// **'Farmer\'s Walk'**
  String get exFarmerWalk;

  /// Button to finish workout
  ///
  /// In en, this message translates to:
  /// **'Finish Workout'**
  String get finishWorkout;

  /// Title for summary dialog
  ///
  /// In en, this message translates to:
  /// **'Workout Summary'**
  String get workoutSummary;

  /// Label for duration
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// Message when no history found
  ///
  /// In en, this message translates to:
  /// **'No previous data to compare'**
  String get noPreviousData;

  /// Encouraging message
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get greatJob;

  /// Button to open the summary of the last finished workout
  ///
  /// In en, this message translates to:
  /// **'View Last Report'**
  String get viewLastReport;

  /// Snackbar message when copying last workout
  ///
  /// In en, this message translates to:
  /// **'Copied from last \${type} workout'**
  String copyLastWorkout(String type);

  /// Comparison dialog title
  ///
  /// In en, this message translates to:
  /// **'Month comparison'**
  String get comparisonTitle;

  /// Start Value
  ///
  /// In en, this message translates to:
  /// **'Start Value'**
  String get startValue;

  /// Current Value
  ///
  /// In en, this message translates to:
  /// **'Current Value'**
  String get currentValue;

  /// Difference
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get difference;

  /// Notifications enabled title
  ///
  /// In en, this message translates to:
  /// **'Notifications Enabled! 🔔'**
  String get notificationsEnabledTitle;

  /// Notifications enabled body
  ///
  /// In en, this message translates to:
  /// **'You will now receive reminders.'**
  String get notificationsEnabledBody;

  /// Weight control section title
  ///
  /// In en, this message translates to:
  /// **'Weight Control'**
  String get weightControl;

  /// Weight chart and reminders subtitle
  ///
  /// In en, this message translates to:
  /// **'Weight Chart and Reminders'**
  String get weightChartAndReminders;

  /// Health page title
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthTitle;

  /// Weight change label
  ///
  /// In en, this message translates to:
  /// **'Weight Change'**
  String get weightChangeLabel;

  /// Gym sessions label
  ///
  /// In en, this message translates to:
  /// **'Gym Sessions'**
  String get gymSessions;

  /// Reminder settings title
  ///
  /// In en, this message translates to:
  /// **'Reminder Settings'**
  String get reminderSettings;

  /// Frequency label
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// Daily frequency option
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Weekly frequency option
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Select time label
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// Reminder set confirmation
  ///
  /// In en, this message translates to:
  /// **'Reminder set for: {time}'**
  String reminderSet(String time);

  /// Edit weight button
  ///
  /// In en, this message translates to:
  /// **'Edit Weight'**
  String get editWeight;

  /// Add weight button
  ///
  /// In en, this message translates to:
  /// **'Add Weight'**
  String get addWeight;

  /// Weight change date range
  ///
  /// In en, this message translates to:
  /// **'Change from {start} to {end}'**
  String weightDateRange(String start, String end);

  /// Save settings button
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// History tab label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Weight history title
  ///
  /// In en, this message translates to:
  /// **'Weight History'**
  String get weightHistory;
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
