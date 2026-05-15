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
  /// **'Gym Tracker'**
  String get appName;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

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
  /// **'Your activity for'**
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

  /// Theme selection section title
  ///
  /// In en, this message translates to:
  /// **'App theme'**
  String get themeSelectionTitle;

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

  /// System mode switch
  ///
  /// In en, this message translates to:
  /// **'System Mode'**
  String get systemMode;

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

  /// Squat using the Smith machine
  ///
  /// In en, this message translates to:
  /// **'Smith Machine Squat'**
  String get exSmithMachineSquat;

  /// Hack squat machine
  ///
  /// In en, this message translates to:
  /// **'Hack Squat'**
  String get exHackSquat;

  /// Stepping backward into a lunge
  ///
  /// In en, this message translates to:
  /// **'Reverse Lunge'**
  String get exReverseLunge;

  /// Leg curl on seated machine
  ///
  /// In en, this message translates to:
  /// **'Seated Leg Curl'**
  String get exSeatedLegCurl;

  /// Glute exercise using low cable
  ///
  /// In en, this message translates to:
  /// **'Cable Pull Through'**
  String get exCablePullThrough;

  /// Bench press with hands close together
  ///
  /// In en, this message translates to:
  /// **'Close Grip Bench Press'**
  String get exCloseGripBenchPress;

  /// Bench press using Smith machine
  ///
  /// In en, this message translates to:
  /// **'Smith Machine Bench Press'**
  String get exSmithMachineBenchPress;

  /// Push-ups with added weight
  ///
  /// In en, this message translates to:
  /// **'Weighted Push-up'**
  String get exWeightedPushUp;

  /// Cable fly from low pulleys
  ///
  /// In en, this message translates to:
  /// **'Low Cable Crossover'**
  String get exLowCableCrossover;

  /// Chest fly on incline bench
  ///
  /// In en, this message translates to:
  /// **'Incline Dumbbell Fly'**
  String get exInclineDumbbellFly;

  /// Lat pulldown using V-bar attachment
  ///
  /// In en, this message translates to:
  /// **'V-Bar Pull-Down'**
  String get exVBarPullDown;

  /// Overhead press using Smith machine
  ///
  /// In en, this message translates to:
  /// **'Smith Machine Shoulder Press'**
  String get exSmithMachineShoulderPress;

  /// Side delts on lateral raise machine
  ///
  /// In en, this message translates to:
  /// **'Machine Lateral Raise'**
  String get exMachineLateralRaise;

  /// Front delt raise using low cable
  ///
  /// In en, this message translates to:
  /// **'Cable Front Raise'**
  String get exCableFrontRaise;

  /// Triceps pushdown using rope attachment
  ///
  /// In en, this message translates to:
  /// **'Rope Pushdown'**
  String get exRopePushdown;

  /// Triceps extension overhead using cable
  ///
  /// In en, this message translates to:
  /// **'Overhead Cable Extension'**
  String get exOverheadCableExtension;

  /// Explosive kettlebell swing
  ///
  /// In en, this message translates to:
  /// **'Kettlebell Swing'**
  String get exKettlebellSwing;

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

  /// Weekly goal section title
  ///
  /// In en, this message translates to:
  /// **'Weekly Goal'**
  String get weeklyGoalTitle;

  /// Weekly goal question
  ///
  /// In en, this message translates to:
  /// **'How many times a week do you plan to workout?'**
  String get weeklyGoalQuestion;

  /// Times per week label
  ///
  /// In en, this message translates to:
  /// **'Times/Week'**
  String get timesPerWeek;

  /// Streak weeks label
  ///
  /// In en, this message translates to:
  /// **'{count}-week streak'**
  String streakWeeks(int count);

  /// Message when weekly goal is met
  ///
  /// In en, this message translates to:
  /// **'Awesome! Weekly goal met.'**
  String get streakKeep;

  /// Message when weekly goal is not met
  ///
  /// In en, this message translates to:
  /// **'Workout {count} more times to keep the streak!'**
  String streakBurn(int count);

  /// Message when streak is lost
  ///
  /// In en, this message translates to:
  /// **'Streak lost. Start a new one this week!'**
  String get streakLostMsg;

  /// Label for week in streak display
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekLabel;

  /// Weekly goal label
  ///
  /// In en, this message translates to:
  /// **'Goal {count}x/week'**
  String goalLabel(int count);

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Set later button text
  ///
  /// In en, this message translates to:
  /// **'Set later'**
  String get setLater;

  /// Text shown when weight is not provided
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get weightNotSet;

  /// Banner text prompting user to enter their weight
  ///
  /// In en, this message translates to:
  /// **'Enter your weight so we can calculate burned calories!'**
  String get weightMissingBanner;

  /// Button to move to the next exercise during workout
  ///
  /// In en, this message translates to:
  /// **'Next Exercise'**
  String get nextExercise;

  /// Confirmation message for sent friend request
  ///
  /// In en, this message translates to:
  /// **'Friend request via link successfully sent!'**
  String get friendRequestSent;

  /// Error message for addition errors
  ///
  /// In en, this message translates to:
  /// **'Addition error: {error}'**
  String additionError(String error);

  /// Hint text shown when entering a username
  ///
  /// In en, this message translates to:
  /// **'Enter a nickname to find friends'**
  String get enterUsernameHint;

  /// Error message when the username field is empty
  ///
  /// In en, this message translates to:
  /// **'Nickname cannot be empty'**
  String get usernameEmptyError;

  /// Error message when the username is less than 3 characters
  ///
  /// In en, this message translates to:
  /// **'Minimum 3 characters'**
  String get usernameTooShortError;

  /// Status message while checking if the username is taken
  ///
  /// In en, this message translates to:
  /// **'Checking availability...'**
  String get usernameChecking;

  /// Status message when the username is free to use
  ///
  /// In en, this message translates to:
  /// **'Nickname is available!'**
  String get usernameAvailable;

  /// Status message when the username is already registered
  ///
  /// In en, this message translates to:
  /// **'This nickname is already taken'**
  String get usernameTaken;

  /// Error message if saving the username fails
  ///
  /// In en, this message translates to:
  /// **'Error saving. Try another nickname.'**
  String get usernameSaveError;

  /// Title of the create username page
  ///
  /// In en, this message translates to:
  /// **'Your Unique Nickname'**
  String get uniqueUsernameTitle;

  /// Description explaining why a username is needed
  ///
  /// In en, this message translates to:
  /// **'Choose a nickname so friends can easily find you in the Gym Tracker community.'**
  String get chooseUsernameDesc;

  /// Label for the username text field
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get usernameLabel;

  /// Rules for creating a username
  ///
  /// In en, this message translates to:
  /// **'Only lowercase letters allowed (no spaces).\nThis nickname is permanent and cannot be changed.'**
  String get usernameRulesDesc;

  /// Button text to save the username and proceed
  ///
  /// In en, this message translates to:
  /// **'Save and Continue'**
  String get saveAndContinue;

  /// Title for the weight reminder dialog
  ///
  /// In en, this message translates to:
  /// **'Weight Reminders ⚖️'**
  String get weightReminderTitle;

  /// Body text for the weight reminder dialog
  ///
  /// In en, this message translates to:
  /// **'Regular weight tracking helps accurately monitor your progress. Do you want to set up reminders so you don\'t forget?'**
  String get weightReminderBody;

  /// Button text to decline setting up reminders
  ///
  /// In en, this message translates to:
  /// **'No, thanks'**
  String get noThanks;

  /// Button text to accept setting up reminders
  ///
  /// In en, this message translates to:
  /// **'Yes, set up'**
  String get yesSetUp;

  /// Message shown when notification permissions are blocked
  ///
  /// In en, this message translates to:
  /// **'Permission blocked. Please enable notifications in phone settings.'**
  String get permissionBlocked;

  /// Button text to open app settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsAction;

  /// Text shown when the user's last seen status is unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownStatus;

  /// Shows the date when the friend was last active
  ///
  /// In en, this message translates to:
  /// **'Last seen in gym: {date}'**
  String lastSeenInGym(String date);

  /// Label for the weight statistic
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get statWeight;

  /// Label for the workout streak statistic
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get statStreak;

  /// Shows the number of weeks for a streak
  ///
  /// In en, this message translates to:
  /// **'{count} w.'**
  String statWeeks(String count);

  /// Label for the monthly workouts statistic
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get statPerMonth;

  /// Shows the number of workouts
  ///
  /// In en, this message translates to:
  /// **'{count} w.'**
  String statWorkouts(String count);

  /// Title for the monthly records section
  ///
  /// In en, this message translates to:
  /// **'🏆 Records this month'**
  String get recordsThisMonth;

  /// Message shown when there are no records for the current month
  ///
  /// In en, this message translates to:
  /// **'No records for this month yet 😔'**
  String get noRecordsThisMonth;

  /// Title for the delete friend confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Remove Friend'**
  String get deleteFriendTitle;

  /// Confirmation message for removing a friend
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from your friends?'**
  String deleteFriendConfirmBody(String name);

  /// Generic cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Generic delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Success message after removing a friend
  ///
  /// In en, this message translates to:
  /// **'{name} removed from friends'**
  String friendDeletedSuccess(String name);

  /// Error message when deleting a friend fails
  ///
  /// In en, this message translates to:
  /// **'Delete error: {error}'**
  String deleteError(String error);

  /// Title for the friends page
  ///
  /// In en, this message translates to:
  /// **'Friends & Community'**
  String get friendsAndCommunity;

  /// Tab title for the user's friends list
  ///
  /// In en, this message translates to:
  /// **'My Friends'**
  String get myFriendsTab;

  /// Tab title for finding friends and managing requests
  ///
  /// In en, this message translates to:
  /// **'Search / Requests'**
  String get searchRequestsTab;

  /// Message shown when the friends list is empty
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any friends yet'**
  String get noFriendsYet;

  /// Button text to navigate to the find friends tab
  ///
  /// In en, this message translates to:
  /// **'Find a friend'**
  String get findFriendBtn;

  /// Text shown when the friend's last workout was very long ago
  ///
  /// In en, this message translates to:
  /// **'A long time ago'**
  String get longTimeAgo;

  /// Text shown when a friend has no workout records
  ///
  /// In en, this message translates to:
  /// **'No records'**
  String get noRecords;

  /// Prefix for showing the best monthly record
  ///
  /// In en, this message translates to:
  /// **'Month record: '**
  String get monthlyRecordPrefix;

  /// Button text to share the user's profile link
  ///
  /// In en, this message translates to:
  /// **'Share profile link'**
  String get shareProfileLink;

  /// Text indicating the manual search option
  ///
  /// In en, this message translates to:
  /// **'Or find manually'**
  String get orFindManually;

  /// Hint text for the friend search input
  ///
  /// In en, this message translates to:
  /// **'Enter Email or @username'**
  String get searchFriendHint;

  /// Helper text for the friend search input
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com or @gymbro'**
  String get searchFriendHelper;

  /// Button text to send a friend request
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addBtn;

  /// Title for the incoming friend requests section
  ///
  /// In en, this message translates to:
  /// **'Incoming requests'**
  String get incomingRequests;

  /// Message shown when there are no incoming friend requests
  ///
  /// In en, this message translates to:
  /// **'No new requests'**
  String get noNewRequests;

  /// Text used when sharing the profile link
  ///
  /// In en, this message translates to:
  /// **'Hi! Add me as a friend in Gym Tracker to follow my workouts: {link}'**
  String shareFriendText(String link);

  /// Subject line when sharing the profile link via email
  ///
  /// In en, this message translates to:
  /// **'Gym Tracker friend request'**
  String get shareFriendSubject;

  /// Success message when a friend request is sent
  ///
  /// In en, this message translates to:
  /// **'Request sent to {email}!'**
  String requestSentTo(String email);

  /// Error message when a searched user is not found
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// Error message when trying to add oneself as a friend
  ///
  /// In en, this message translates to:
  /// **'You cannot add yourself'**
  String get cannotAddSelf;

  /// Error message for invalid user data
  ///
  /// In en, this message translates to:
  /// **'User data error'**
  String get userDataError;

  /// Generic success message for a sent friend request
  ///
  /// In en, this message translates to:
  /// **'Request sent!'**
  String get requestSentSuccess;

  /// Text for the previous period option
  ///
  /// In en, this message translates to:
  /// **'Previous period'**
  String get previousPeriod;

  /// Title for the enable notifications dialog
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications? 🔔'**
  String get enableNotificationsTitle;

  /// Body text for the enable notifications dialog
  ///
  /// In en, this message translates to:
  /// **'This will allow us to send you reminders about your workouts and weight tracking so you don\'t lose your progress.'**
  String get enableNotificationsBody;

  /// Error message when picking an avatar fails
  ///
  /// In en, this message translates to:
  /// **'Error picking photo: {error}'**
  String errorPickingPhoto(String error);

  /// Default fallback username when none is set
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUser;

  /// Label for the friends stat card
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsLabel;

  /// Label for the community stat card value
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityLabel;

  /// Label for the total time spent in the gym
  ///
  /// In en, this message translates to:
  /// **'In Gym'**
  String get inGymLabel;

  /// Short abbreviation for hours
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hoursShort;

  /// Short abbreviation for minutes
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minutesShort;

  /// Label for the average workout duration
  ///
  /// In en, this message translates to:
  /// **'Average Time'**
  String get avarageTimeLabel;

  /// Button to open the personal records page
  ///
  /// In en, this message translates to:
  /// **'Personal Records'**
  String get personalRecordsTitle;

  /// Short abbreviation for one rep max
  ///
  /// In en, this message translates to:
  /// **'1RM'**
  String get oneRepMaxShort;

  /// Tooltip explaining what the one rep max stat means
  ///
  /// In en, this message translates to:
  /// **'Estimated maximum weight you can lift for one repetition based on your workout history.'**
  String get oneRepMaxTooltip;

  /// Label for cardio duration in minutes
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get cardioMin;

  /// Label for cardio distance in kilometers
  ///
  /// In en, this message translates to:
  /// **'Km'**
  String get cardioKm;

  /// Button text to add weight to a bodyweight exercise
  ///
  /// In en, this message translates to:
  /// **'+ Weight'**
  String get bodyweightAddWeight;

  /// Title for the recover access page
  ///
  /// In en, this message translates to:
  /// **'Recover Access'**
  String get recoverAccessTitle;

  /// Heading for creating a new password
  ///
  /// In en, this message translates to:
  /// **'Create a new password'**
  String get createNewPasswordTitle;

  /// Instructions for creating a new password
  ///
  /// In en, this message translates to:
  /// **'Create a strong password with at least 6 characters.'**
  String get createNewPasswordSubtitle;

  /// Label for the new password input field
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// Error message when password field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get errPleaseEnterPassword;

  /// Error message when confirm password field is empty
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get errPleaseConfirmPassword;

  /// Button text to save the new password
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get savePasswordAction;

  /// Success message after changing the password
  ///
  /// In en, this message translates to:
  /// **'Password successfully changed! You can now log in.'**
  String get passwordChangedSuccess;

  /// Prefix used before displaying system errors
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorPrefix;

  /// Option to use the device's system language
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemLanguage;

  /// Title for the streak reminder notification
  ///
  /// In en, this message translates to:
  /// **'Your streak is in danger! 🔥'**
  String get streakWarningTitle;

  /// Body for the streak reminder notification
  ///
  /// In en, this message translates to:
  /// **'You haven\'t worked out today. Do a short warm-up to keep your streak alive!'**
  String get streakWarningBody;

  /// Funny loading phrase about bench press
  ///
  /// In en, this message translates to:
  /// **'Looking for an available bench...'**
  String get loadingJoke1;

  /// Funny loading phrase about cardio
  ///
  /// In en, this message translates to:
  /// **'Coming up with an excuse to skip cardio...'**
  String get loadingJoke2;

  /// Funny loading phrase about muscle fatigue
  ///
  /// In en, this message translates to:
  /// **'Convincing your muscles it\'s not over yet...'**
  String get loadingJoke3;

  /// Funny loading phrase about the last set
  ///
  /// In en, this message translates to:
  /// **'Counting how many times you said \'last set\'...'**
  String get loadingJoke4;

  /// Funny loading phrase about weight and ego
  ///
  /// In en, this message translates to:
  /// **'Adding +5 kg to your self-esteem...'**
  String get loadingJoke5;

  /// Funny loading phrase about motivation
  ///
  /// In en, this message translates to:
  /// **'Searching for your motivation under the dumbbells...'**
  String get loadingJoke6;

  /// Funny loading phrase about headphones
  ///
  /// In en, this message translates to:
  /// **'Untangling earphones before a heavy set...'**
  String get loadingJoke7;

  /// Funny loading phrase about waiting for a machine
  ///
  /// In en, this message translates to:
  /// **'Waiting for that guy to get off the machine...'**
  String get loadingJoke8;

  /// Funny loading phrase about counting plates
  ///
  /// In en, this message translates to:
  /// **'Trying to remember how many plates were on the bar...'**
  String get loadingJoke9;

  /// Funny loading phrase about drinking water
  ///
  /// In en, this message translates to:
  /// **'Taking a water break and moving on...'**
  String get loadingJoke10;

  /// Funny loading phrase about Romanian deadlift
  ///
  /// In en, this message translates to:
  /// **'Gathering strength for the perfect Romanian deadlift...'**
  String get loadingJoke11;

  /// Funny loading phrase about saving data
  ///
  /// In en, this message translates to:
  /// **'Stretching fingers before saving...'**
  String get loadingJoke12;

  /// Funny loading phrase about leg day
  ///
  /// In en, this message translates to:
  /// **'Mentally preparing for leg day...'**
  String get loadingJoke13;

  /// Category name for user-created exercises
  ///
  /// In en, this message translates to:
  /// **'Custom Exercises'**
  String get customExerciseCategory;

  /// Category for leg exercises
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get catLegs;

  /// Category for chest exercises
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get catChest;

  /// Category for back exercises
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get catBack;

  /// Category for shoulder exercises
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get catShoulders;

  /// Category for arm exercises
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get catArms;

  /// Category for abdominal exercises
  ///
  /// In en, this message translates to:
  /// **'Abs'**
  String get catAbs;

  /// Category for cardio exercises
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get catCardio;

  /// Category for calf exercises
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get catCalves;

  /// Category for full body exercises
  ///
  /// In en, this message translates to:
  /// **'Full Body'**
  String get catFullBody;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get eqBarbell;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Dumbbell'**
  String get eqDumbbell;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Machine'**
  String get eqMachine;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get eqBodyweight;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Bench'**
  String get eqBench;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Incline bench'**
  String get eqInclineBench;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Decline bench'**
  String get eqDeclineBench;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Pull-up bar'**
  String get eqPullUpBar;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Dip bars'**
  String get eqDipBar;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Gym mat'**
  String get eqMat;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Cable machine'**
  String get eqCable;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Kettlebell'**
  String get eqKettlebell;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Smith machine'**
  String get eqSmithMachine;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'EZ-bar'**
  String get eqEzBar;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Rope attachment'**
  String get eqRope;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Roman chair'**
  String get eqRomanChair;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Pec deck machine'**
  String get eqPecDeck;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Treadmill'**
  String get eqTreadmill;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Elliptical'**
  String get eqElliptical;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Rowing machine'**
  String get eqRowingMachine;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Ab wheel'**
  String get eqAbWheel;

  /// Equipment type
  ///
  /// In en, this message translates to:
  /// **'Weight plate'**
  String get eqWeightPlate;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Quadriceps'**
  String get musQuads;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get musGlutes;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get musHamstrings;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get musCalves;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Soleus'**
  String get musSoleus;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Pectorals'**
  String get musChest;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Upper chest'**
  String get musUpperChest;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Lower chest'**
  String get musLowerChest;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Inner chest'**
  String get musInnerChest;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Lats'**
  String get musLats;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Mid back'**
  String get musMidBack;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Lower back'**
  String get musLowerBack;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Trapezius'**
  String get musTraps;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Front delts'**
  String get musFrontDelts;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Side delts'**
  String get musSideDelts;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Rear delts'**
  String get musRearDelts;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get musBiceps;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get musTriceps;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Forearms'**
  String get musForearms;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Brachialis'**
  String get musBrachialis;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Abs'**
  String get musAbs;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Lower abs'**
  String get musLowerAbs;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Obliques'**
  String get musObliques;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get musCore;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get musHeart;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Hip flexors'**
  String get musHipFlexors;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Abductors'**
  String get musAbductors;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Adductors'**
  String get musAdductors;

  /// Muscle group
  ///
  /// In en, this message translates to:
  /// **'Rotator cuff'**
  String get musRotatorCuff;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your back straight and look forward.\nSquat down until your thighs are parallel to the floor.\nPush through your heels on the way up.'**
  String get tipsSquat;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your elbows as high as possible.\nThe barbell should rest on your front deltoids.\nKeep your torso upright.'**
  String get tipsFrontSquat;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Hold the weight close to your chest.\nSquat deep, pushing your knees outward.'**
  String get tipsGobletSquat;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Place your feet slightly forward to emphasize the glutes.\nLean back against the bar for support.'**
  String get tipsSmithMachineSquat;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your back flat against the pad.\nDo not lift your heels off the platform.'**
  String get tipsHackSquat;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Take a wide enough step.\nYour back knee should almost touch the floor.\nKeep your front knee behind your toes.'**
  String get tipsLunge;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Maintain balance and do not rush.\nKeep your torso upright.'**
  String get tipsWalkingLunge;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Stepping back reduces stress on the knee joints.\nPush off with your front leg to return.'**
  String get tipsReverseLunge;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Place your rear foot on a bench.\nLean your torso slightly forward to target the glutes.'**
  String get tipsBulgarianSplitSquat;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Do not fully lock your knees at the top of the movement.\nKeep your lower back pressed against the seat.'**
  String get tipsLegPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep a 90-degree angle at your knees.\nPress your entire back against the wall.'**
  String get tipsWallSit;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your hips firmly on the seat.\nControl the weight on the way down.'**
  String get tipsLegExtension;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Perform smooth, controlled movements.\nKeep your hips pressed against the pad.'**
  String get tipsLegCurl;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Secure the leg pads firmly.\nCurl your legs as far back as possible.'**
  String get tipsSeatedLegCurl;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep the bar as close to your shins as possible.\nInitiate the lift by pushing with your legs.\nKeep your back perfectly straight.'**
  String get tipsDeadlift;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Take a very wide stance.\nKeep your torso more upright than in a conventional deadlift.'**
  String get tipsSumoDeadlift;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Push your hips back as far as possible.\nKeep a slight bend in your knees.\nFeel the stretch in your hamstrings.'**
  String get tipsRomanianDeadlift;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Rest the bar on your traps, similar to a squat.\nHinge at the hips, keeping your legs slightly bent.'**
  String get tipsGoodMorning;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Rest your shoulder blades on the bench.\nPause at the top and squeeze your glutes.\nTuck your chin to your chest.'**
  String get tipsHipThrust;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Drive through your heels.\nDo not hyperextend your lower back at the top.'**
  String get tipsGluteBridge;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Face away from the machine.\nThe movement should come from hinging at the hips.'**
  String get tipsCablePullThrough;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Lower your heels as much as possible.\nRaise up on your toes as high as you can.'**
  String get tipsStandingCalfRaise;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Sit up straight and secure the knee pads.\nMove slowly and with control.'**
  String get tipsSeatedCalfRaise;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your back straight while leaning forward.\nStretch your calves at the bottom of the movement.'**
  String get tipsDonkeyCalfRaise;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Push your legs apart in a smooth motion.\nControl the weight as you bring your legs back.'**
  String get tipsAbductorMachine;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Squeeze your legs together, feeling the inner thighs work.\nKeep your back pressed against the seat.'**
  String get tipsAdductorMachine;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Retract your shoulder blades and keep them down.\nKeep your feet firmly planted on the floor.\nLower the bar to your nipple line.'**
  String get tipsBenchPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Set the bench angle to 30-45 degrees.\nLower the bar closer to your collarbones.'**
  String get tipsInclineBenchPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Secure your legs under the pads.\nLower the bar to your lower chest.'**
  String get tipsDeclineBenchPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Use a shoulder-width grip or slightly narrower.\nKeep your elbows tucked close to your body.'**
  String get tipsCloseGripBenchPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Adjust the bench so the bar lowers to the middle of your chest.\nControl the descent.'**
  String get tipsSmithMachineBenchPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Dumbbells allow for a deeper range of motion.\nBring the dumbbells together at the top, squeezing your chest.'**
  String get tipsDumbbellBenchPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your elbows at about a 45-degree angle to your body.\nDo not drop the dumbbells quickly at the bottom.'**
  String get tipsInclineDumbbellPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your body in a straight line.\nKeep your elbows tucked at a 45-degree angle.'**
  String get tipsPushUp;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Form a diamond shape with your index fingers and thumbs.\nLower your chest toward your hands.'**
  String get tipsDiamondPushUp;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Have a partner place a weight plate on your upper back.\nMaintain perfect form, do not let your lower back sag.'**
  String get tipsWeightedPushUp;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Lean forward slightly to emphasize the chest.\nDo not go down too deep to protect your shoulders.'**
  String get tipsDip;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your elbows slightly bent.\nSqueeze your chest muscles as you bring the handles together.'**
  String get tipsMachineFly;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Lean forward slightly.\nThe movement should feel like \'hugging a tree\'.'**
  String get tipsCableCrossover;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Pull the handles from the bottom up.\nBring your hands together in front of your upper chest.'**
  String get tipsLowCableCrossover;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Open your arms until you feel a mild stretch in your chest.\nDo not fully lock out your elbows.'**
  String get tipsDumbbellFly;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Set the bench to a 30-degree angle.\nControl the movement, avoiding sudden jerks.'**
  String get tipsInclineDumbbellFly;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Lie across or along the bench.\nLower the dumbbell behind your head with slightly bent arms.'**
  String get tipsPullover;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Adjust the seat so the handles are at chest level.\nPress evenly with both arms.'**
  String get tipsChestPressMachine;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Start the pull by bringing your shoulder blades down.\nPull your chest toward the bar, not your chin.\nControl the descent, do not drop your body.'**
  String get tipsPullUp;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Use an underhand grip.\nKeep your elbows close to your body.'**
  String get tipsChinUp;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Do not lean back too far.\nPull the bar down to your upper chest.'**
  String get tipsLatPullDown;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Squeeze your shoulder blades at the bottom.\nUse a narrow grip attachment.'**
  String get tipsCloseGripLatPullDown;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Pull the handle to your solar plexus.\nFeel the maximum contraction of your shoulder blades.'**
  String get tipsVBarPullDown;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Lean your torso almost parallel to the floor.\nPull the bar to your waist, not your chest.'**
  String get tipsBentOverRow;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'An underhand grip helps keep elbows close to the body.\nControl the weight when lowering the barbell.'**
  String get tipsReverseGripRow;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Support yourself with a knee and hand on a bench for stability.\nPull the dumbbell to your hip, not straight up.'**
  String get tipsSingleArmDumbbellRow;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Maintain a natural arch in your lower back.\nDo not jerk the weight with your torso.'**
  String get tipsTBarRow;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Sit up straight and avoid leaning back excessively.\nSqueeze your shoulder blades together at the end of the movement.'**
  String get tipsSeatedCableRow;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Press your chest firmly against the pad.\nFocus on driving your elbows back.'**
  String get tipsMachineRow;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your arms slightly bent but locked.\nThe movement should only occur at the shoulder joint.'**
  String get tipsStraightArmPulldown;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Do not hyperextend your back at the top.\nLower yourself slowly, feeling the stretch.'**
  String get tipsHyperextension;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Set the barbell at knee height.\nPull the weight by extending your hips and back.'**
  String get tipsRackPull;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Squeeze your glutes and core to create a rigid base.\nThe bar should travel in a straight line close to your face.'**
  String get tipsOverheadPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Sit on a bench with back support to stabilize your lower back.\nLower the dumbbells to ear level.'**
  String get tipsSeatedDumbbellPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Adjust the bench so the bar lowers in front of your face.\nDo not fully lock out your elbows at the top.'**
  String get tipsSmithMachineShoulderPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'At the bottom, your palms should face you.\nRotate your wrists as you press the dumbbells up.'**
  String get tipsArnoldPress;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Raise your arms as if you are pouring water from pitchers.\nDo not use momentum from your torso.'**
  String get tipsLateralRaise;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'The cable provides constant tension.\nRun the cable behind your back or in front of you.'**
  String get tipsCableLateralRaise;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Sit up straight and focus on raising your elbows.\nThe weight should be comfortable enough to maintain good form.'**
  String get tipsMachineLateralRaise;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Raise your arms to eye level.\nAvoid swinging your torso.'**
  String get tipsFrontRaise;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Stand facing away from the machine and run the cable between your legs.\nKeep your elbows slightly bent.'**
  String get tipsCableFrontRaise;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Lean your torso parallel to the floor.\nFocus on squeezing the rear delts, not just your shoulder blades.'**
  String get tipsRearDeltRaise;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Sit facing the machine.\nKeep your arms parallel to the floor.'**
  String get tipsReversePecDeck;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Pull the rope to eye level.\nExternally rotate your arms at the end of the movement.'**
  String get tipsFacePull;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Use a shoulder-width or slightly wider grip.\nPull your elbows higher than your hands.'**
  String get tipsUprightRow;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Simply raise your shoulders straight up toward your ears.\nDo not roll your shoulders.'**
  String get tipsShoulderShrug;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your elbows tucked into your sides.\nAvoid swinging your torso.'**
  String get tipsBicepsCurl;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'You can perform this alternating arms.\nRotate your wrist (supinate) during the curl.'**
  String get tipsDumbbellCurl;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Hold the dumbbells with a neutral grip (palms facing each other).\nThe movement should be smooth and controlled.'**
  String get tipsHammerCurl;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Press your triceps firmly against the pad.\nDo not fully extend your arms to protect your joints.'**
  String get tipsPreacherCurl;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Rest your elbow on the inner part of your thigh.\nDo not use your shoulder or torso to assist.'**
  String get tipsConcentrationCurl;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'The cable creates constant tension in the muscle.\nTake a step back from the machine to increase the range of motion.'**
  String get tipsCableCurl;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Curl the dumbbells with an underhand grip (palms up).\nLower the dumbbells with an overhand grip (palms down).'**
  String get tipsZottmanCurl;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Can be performed with one or two hands.\nYour elbows should point straight up.'**
  String get tipsTricepsExtension;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Lower the bar behind your head or to your forehead.\nYour elbows should not flare out to the sides.'**
  String get tipsSkullCrusher;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Only your forearms should move.\nFully extend your arms at the bottom.'**
  String get tipsTricepPushdown;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Pull the ends of the rope apart at the bottom.\nKeep your torso leaned slightly forward.'**
  String get tipsRopePushdown;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Stand facing away from the cable machine.\nFully stretch the triceps by letting the rope go deep behind your head.'**
  String get tipsOverheadCableExtension;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Sit up straight and press your back against the pad.\nPress the handles until your arms are fully extended.'**
  String get tipsTricepDipMachine;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your hips as close to the bench as possible.\nLower yourself until your elbows are at a 90-degree angle.'**
  String get tipsBenchDip;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Do not lift your lower back off the floor.\nCrunch by bringing your ribs closer to your pelvis.'**
  String get tipsCrunch;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Kneel facing away from the machine.\nCrunch using your abs, do not pull with your arms.'**
  String get tipsCableCrunch;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'You can anchor your feet.\nLift your entire torso until your chest touches your knees.'**
  String get tipsSitUp;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Press your lower back into the floor.\nLower your legs slowly without letting your heels touch the ground.'**
  String get tipsLegRaise;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Avoid swinging your body.\nTry to tilt your pelvis upward at the top of the movement.'**
  String get tipsLegRaiseHang;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your back straight and lean back slightly.\nRotate your shoulders, not just your arms.'**
  String get tipsRussianTwist;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Your body should form a straight line from head to heels.\nDo not lift your hips or let your lower back sag.'**
  String get tipsPlank;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Your elbow should be directly under your shoulder.\nDo not let your hips sag.'**
  String get tipsSidePlank;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your back slightly rounded and abs tight.\nDo not arch your lower back when fully extended.'**
  String get tipsAbWheelRollout;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Bring your right elbow to your left knee and vice versa.\nKeep your mouth open and breathe evenly.'**
  String get tipsBicycleCrunch;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Pull the cable diagonally from top to bottom.\nLock your hips and rotate only your upper torso.'**
  String get tipsWoodchopper;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Maintain good posture and do not slouch.\nTo increase intensity, raise the incline rather than just the speed.'**
  String get tipsCardioTreadmill;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Use the handles to actively engage your upper body.\nKeep your heels on the pedals.'**
  String get tipsCardioElliptical;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'The movement consists of a leg drive followed by an arm pull.\nKeep your back straight throughout the movement.'**
  String get tipsCardioRowing;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'Keep your back perfectly straight and shoulders back.\nTake short, quick steps.'**
  String get tipsFarmerWalk;

  /// Tips for exercise
  ///
  /// In en, this message translates to:
  /// **'The momentum comes entirely from your hips (a hinge movement).\nDo not lift the kettlebell with your arms or shoulders.'**
  String get tipsKettlebellSwing;
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
