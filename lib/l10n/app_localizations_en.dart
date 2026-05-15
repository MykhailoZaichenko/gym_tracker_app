// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Gym Tracker';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved';

  @override
  String get close => 'Close';

  @override
  String get discard => 'Discard';

  @override
  String get edit => 'Edit';

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
  String get repsLabel => 'Reps';

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
  String copyPreviousWorkout(String type) {
    return 'Copy previous $type workout';
  }

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
  String get yourProgressFor => 'Your activity for';

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
  String get themeSelectionTitle => 'App theme';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemMode => 'System Mode';

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
  String get exFrontSquat => 'Front Squat';

  @override
  String get exGobletSquat => 'Goblet Squat';

  @override
  String get exLunge => 'Lunge';

  @override
  String get exWalkingLunge => 'Walking Lunge';

  @override
  String get exBulgarianSplitSquat => 'Bulgarian Split Squat';

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
  String get exSumoDeadlift => 'Sumo Deadlift';

  @override
  String get exRomanianDeadlift => 'Romanian Deadlift';

  @override
  String get exGoodMorning => 'Good Morning';

  @override
  String get exHipThrust => 'Hip Thrust';

  @override
  String get exGluteBridge => 'Glute Bridge';

  @override
  String get exStandingCalfRaise => 'Standing Calf Raise';

  @override
  String get exSeatedCalfRaise => 'Seated Calf Raise';

  @override
  String get exDonkeyCalfRaise => 'Donkey Calf Raise';

  @override
  String get exAbductorMachine => 'Abductor Machine';

  @override
  String get exAdductorMachine => 'Adductor Machine';

  @override
  String get exBenchPress => 'Bench Press';

  @override
  String get exInclineBenchPress => 'Incline Bench Press';

  @override
  String get exDeclineBenchPress => 'Decline Bench Press';

  @override
  String get exDumbbellBenchPress => 'Dumbbell Bench Press';

  @override
  String get exInclineDumbbellPress => 'Incline Dumbbell Press';

  @override
  String get exPushUp => 'Push-up';

  @override
  String get exDiamondPushUp => 'Diamond Push-up';

  @override
  String get exDip => 'Dip';

  @override
  String get exMachineFly => 'Machine Fly (Pec Deck)';

  @override
  String get exCableCrossover => 'Cable Crossover';

  @override
  String get exDumbbellFly => 'Dumbbell Fly';

  @override
  String get exPullover => 'Pullover';

  @override
  String get exChestPressMachine => 'Chest Press Machine';

  @override
  String get exPullUp => 'Pull-up';

  @override
  String get exChinUp => 'Chin-up';

  @override
  String get exLatPullDown => 'Lat Pull-Down';

  @override
  String get exCloseGripLatPullDown => 'Close Grip Lat Pull-Down';

  @override
  String get exBentOverRow => 'Bent-Over Row';

  @override
  String get exReverseGripRow => 'Reverse Grip Row';

  @override
  String get exSingleArmDumbbellRow => 'Single Arm Dumbbell Row';

  @override
  String get exTBarRow => 'T-Bar Row';

  @override
  String get exSeatedCableRow => 'Seated Cable Row';

  @override
  String get exMachineRow => 'Machine Row';

  @override
  String get exStraightArmPulldown => 'Straight-Arm Pulldown';

  @override
  String get exHyperextension => 'Hyperextension';

  @override
  String get exRackPull => 'Rack Pull';

  @override
  String get exOverheadPress => 'Overhead Press';

  @override
  String get exSeatedDumbbellPress => 'Seated Dumbbell Press';

  @override
  String get exArnoldPress => 'Arnold Press';

  @override
  String get exLateralRaise => 'Lateral Raise';

  @override
  String get exCableLateralRaise => 'Cable Lateral Raise';

  @override
  String get exFrontRaise => 'Front Raise';

  @override
  String get exRearDeltRaise => 'Rear Delt Raise';

  @override
  String get exReversePecDeck => 'Reverse Pec Deck';

  @override
  String get exFacePull => 'Face Pull';

  @override
  String get exUprightRow => 'Upright Row';

  @override
  String get exShoulderShrug => 'Shrug';

  @override
  String get exBicepsCurl => 'Biceps Curl';

  @override
  String get exDumbbellCurl => 'Dumbbell Curl';

  @override
  String get exHammerCurl => 'Hammer Curl';

  @override
  String get exPreacherCurl => 'Preacher Curl';

  @override
  String get exConcentrationCurl => 'Concentration Curl';

  @override
  String get exCableCurl => 'Cable Curl';

  @override
  String get exZottmanCurl => 'Zottman Curl';

  @override
  String get exTricepsExtension => 'Overhead Triceps Extension';

  @override
  String get exSkullCrusher => 'Skull Crusher';

  @override
  String get exTricepPushdown => 'Tricep Pushdown';

  @override
  String get exTricepDipMachine => 'Tricep Dip Machine';

  @override
  String get exBenchDip => 'Bench Dip';

  @override
  String get exCrunch => 'Crunch';

  @override
  String get exCableCrunch => 'Cable Crunch';

  @override
  String get exSitUp => 'Sit-up';

  @override
  String get exLegRaise => 'Leg Raise';

  @override
  String get exLegRaiseHang => 'Hanging Leg Raise';

  @override
  String get exRussianTwist => 'Russian Twist';

  @override
  String get exPlank => 'Plank';

  @override
  String get exSidePlank => 'Side Plank';

  @override
  String get exAbWheelRollout => 'Ab Wheel Rollout';

  @override
  String get exBicycleCrunch => 'Bicycle Crunch';

  @override
  String get exWoodchopper => 'Cable Woodchopper';

  @override
  String get exCardioTreadmill => 'Treadmill';

  @override
  String get exCardioElliptical => 'Elliptical';

  @override
  String get exCardioRowing => 'Rowing Machine';

  @override
  String get exFarmerWalk => 'Farmer\'s Walk';

  @override
  String get exSmithMachineSquat => 'Smith Machine Squat';

  @override
  String get exHackSquat => 'Hack Squat';

  @override
  String get exReverseLunge => 'Reverse Lunge';

  @override
  String get exSeatedLegCurl => 'Seated Leg Curl';

  @override
  String get exCablePullThrough => 'Cable Pull Through';

  @override
  String get exCloseGripBenchPress => 'Close Grip Bench Press';

  @override
  String get exSmithMachineBenchPress => 'Smith Machine Bench Press';

  @override
  String get exWeightedPushUp => 'Weighted Push-up';

  @override
  String get exLowCableCrossover => 'Low Cable Crossover';

  @override
  String get exInclineDumbbellFly => 'Incline Dumbbell Fly';

  @override
  String get exVBarPullDown => 'V-Bar Pull-Down';

  @override
  String get exSmithMachineShoulderPress => 'Smith Machine Shoulder Press';

  @override
  String get exMachineLateralRaise => 'Machine Lateral Raise';

  @override
  String get exCableFrontRaise => 'Cable Front Raise';

  @override
  String get exRopePushdown => 'Rope Pushdown';

  @override
  String get exOverheadCableExtension => 'Overhead Cable Extension';

  @override
  String get exKettlebellSwing => 'Kettlebell Swing';

  @override
  String get finishWorkout => 'Finish Workout';

  @override
  String get workoutSummary => 'Workout Summary';

  @override
  String get durationLabel => 'Duration';

  @override
  String get noPreviousData => 'No previous data to compare';

  @override
  String get greatJob => 'Great Job!';

  @override
  String get viewLastReport => 'View Last Report';

  @override
  String copyLastWorkout(String type) {
    return 'Copied from last \$$type workout';
  }

  @override
  String get comparisonTitle => 'Month comparison';

  @override
  String get startValue => 'Start Value';

  @override
  String get currentValue => 'Current Value';

  @override
  String get difference => 'Difference';

  @override
  String get notificationsEnabledTitle => 'Notifications Enabled! 🔔';

  @override
  String get notificationsEnabledBody => 'You will now receive reminders.';

  @override
  String get weightControl => 'Weight Control';

  @override
  String get weightChartAndReminders => 'Weight Chart and Reminders';

  @override
  String get healthTitle => 'Health';

  @override
  String get weightChangeLabel => 'Weight Change';

  @override
  String get gymSessions => 'Gym Sessions';

  @override
  String get reminderSettings => 'Reminder Settings';

  @override
  String get frequency => 'Frequency';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get selectTime => 'Select Time';

  @override
  String reminderSet(String time) {
    return 'Reminder set for: $time';
  }

  @override
  String get editWeight => 'Edit Weight';

  @override
  String get addWeight => 'Add Weight';

  @override
  String weightDateRange(String start, String end) {
    return 'Change from $start to $end';
  }

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get history => 'History';

  @override
  String get weightHistory => 'Weight History';

  @override
  String get weeklyGoalTitle => 'Weekly Goal';

  @override
  String get weeklyGoalQuestion =>
      'How many times a week do you plan to workout?';

  @override
  String get timesPerWeek => 'Times/Week';

  @override
  String streakWeeks(int count) {
    return '$count-week streak';
  }

  @override
  String get streakKeep => 'Awesome! Weekly goal met.';

  @override
  String streakBurn(int count) {
    return 'Workout $count more times to keep the streak!';
  }

  @override
  String get streakLostMsg => 'Streak lost. Start a new one this week!';

  @override
  String get weekLabel => 'Week';

  @override
  String goalLabel(int count) {
    return 'Goal ${count}x/week';
  }

  @override
  String get skip => 'Skip';

  @override
  String get setLater => 'Set later';

  @override
  String get weightNotSet => 'Not set';

  @override
  String get weightMissingBanner =>
      'Enter your weight so we can calculate burned calories!';

  @override
  String get nextExercise => 'Next Exercise';

  @override
  String get friendRequestSent => 'Friend request via link successfully sent!';

  @override
  String additionError(String error) {
    return 'Addition error: $error';
  }

  @override
  String get enterUsernameHint => 'Enter a nickname to find friends';

  @override
  String get usernameEmptyError => 'Nickname cannot be empty';

  @override
  String get usernameTooShortError => 'Minimum 3 characters';

  @override
  String get usernameChecking => 'Checking availability...';

  @override
  String get usernameAvailable => 'Nickname is available!';

  @override
  String get usernameTaken => 'This nickname is already taken';

  @override
  String get usernameSaveError => 'Error saving. Try another nickname.';

  @override
  String get uniqueUsernameTitle => 'Your Unique Nickname';

  @override
  String get chooseUsernameDesc =>
      'Choose a nickname so friends can easily find you in the Gym Tracker community.';

  @override
  String get usernameLabel => 'Nickname';

  @override
  String get usernameRulesDesc =>
      'Only lowercase letters allowed (no spaces).\nThis nickname is permanent and cannot be changed.';

  @override
  String get saveAndContinue => 'Save and Continue';

  @override
  String get weightReminderTitle => 'Weight Reminders ⚖️';

  @override
  String get weightReminderBody =>
      'Regular weight tracking helps accurately monitor your progress. Do you want to set up reminders so you don\'t forget?';

  @override
  String get noThanks => 'No, thanks';

  @override
  String get yesSetUp => 'Yes, set up';

  @override
  String get permissionBlocked =>
      'Permission blocked. Please enable notifications in phone settings.';

  @override
  String get settingsAction => 'Settings';

  @override
  String get unknownStatus => 'Unknown';

  @override
  String lastSeenInGym(String date) {
    return 'Last seen in gym: $date';
  }

  @override
  String get statWeight => 'Weight';

  @override
  String get statStreak => 'Streak';

  @override
  String statWeeks(String count) {
    return '$count w.';
  }

  @override
  String get statPerMonth => 'This month';

  @override
  String statWorkouts(String count) {
    return '$count w.';
  }

  @override
  String get recordsThisMonth => '🏆 Records this month';

  @override
  String get noRecordsThisMonth => 'No records for this month yet 😔';

  @override
  String get deleteFriendTitle => 'Remove Friend';

  @override
  String deleteFriendConfirmBody(String name) {
    return 'Are you sure you want to remove $name from your friends?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String friendDeletedSuccess(String name) {
    return '$name removed from friends';
  }

  @override
  String deleteError(String error) {
    return 'Delete error: $error';
  }

  @override
  String get friendsAndCommunity => 'Friends & Community';

  @override
  String get myFriendsTab => 'My Friends';

  @override
  String get searchRequestsTab => 'Search / Requests';

  @override
  String get noFriendsYet => 'You don\'t have any friends yet';

  @override
  String get findFriendBtn => 'Find a friend';

  @override
  String get longTimeAgo => 'A long time ago';

  @override
  String get noRecords => 'No records';

  @override
  String get monthlyRecordPrefix => 'Month record: ';

  @override
  String get shareProfileLink => 'Share profile link';

  @override
  String get orFindManually => 'Or find manually';

  @override
  String get searchFriendHint => 'Enter Email or @username';

  @override
  String get searchFriendHelper => 'example@gmail.com or @gymbro';

  @override
  String get addBtn => 'Add';

  @override
  String get incomingRequests => 'Incoming requests';

  @override
  String get noNewRequests => 'No new requests';

  @override
  String shareFriendText(String link) {
    return 'Hi! Add me as a friend in Gym Tracker to follow my workouts: $link';
  }

  @override
  String get shareFriendSubject => 'Gym Tracker friend request';

  @override
  String requestSentTo(String email) {
    return 'Request sent to $email!';
  }

  @override
  String get userNotFound => 'User not found';

  @override
  String get cannotAddSelf => 'You cannot add yourself';

  @override
  String get userDataError => 'User data error';

  @override
  String get requestSentSuccess => 'Request sent!';

  @override
  String get previousPeriod => 'Previous period';

  @override
  String get enableNotificationsTitle => 'Enable Notifications? 🔔';

  @override
  String get enableNotificationsBody =>
      'This will allow us to send you reminders about your workouts and weight tracking so you don\'t lose your progress.';

  @override
  String errorPickingPhoto(String error) {
    return 'Error picking photo: $error';
  }

  @override
  String get defaultUser => 'User';

  @override
  String get friendsLabel => 'Friends';

  @override
  String get communityLabel => 'Community';

  @override
  String get inGymLabel => 'In Gym';

  @override
  String get hoursShort => 'h';

  @override
  String get minutesShort => 'm';

  @override
  String get avarageTimeLabel => 'Average Time';

  @override
  String get personalRecordsTitle => 'Personal Records';

  @override
  String get oneRepMaxShort => '1RM';

  @override
  String get oneRepMaxTooltip =>
      'Estimated maximum weight you can lift for one repetition based on your workout history.';

  @override
  String get cardioMin => 'Min';

  @override
  String get cardioKm => 'Km';

  @override
  String get bodyweightAddWeight => '+ Weight';

  @override
  String get recoverAccessTitle => 'Recover Access';

  @override
  String get createNewPasswordTitle => 'Create a new password';

  @override
  String get createNewPasswordSubtitle =>
      'Create a strong password with at least 6 characters.';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get errPleaseEnterPassword => 'Please enter a password';

  @override
  String get errPleaseConfirmPassword => 'Please confirm your password';

  @override
  String get savePasswordAction => 'Save password';

  @override
  String get passwordChangedSuccess =>
      'Password successfully changed! You can now log in.';

  @override
  String get errorPrefix => 'Error';

  @override
  String get systemLanguage => 'System default';

  @override
  String get streakWarningTitle => 'Your streak is in danger! 🔥';

  @override
  String get streakWarningBody =>
      'You haven\'t worked out today. Do a short warm-up to keep your streak alive!';

  @override
  String get loadingJoke1 => 'Looking for an available bench...';

  @override
  String get loadingJoke2 => 'Coming up with an excuse to skip cardio...';

  @override
  String get loadingJoke3 => 'Convincing your muscles it\'s not over yet...';

  @override
  String get loadingJoke4 => 'Counting how many times you said \'last set\'...';

  @override
  String get loadingJoke5 => 'Adding +5 kg to your self-esteem...';

  @override
  String get loadingJoke6 =>
      'Searching for your motivation under the dumbbells...';

  @override
  String get loadingJoke7 => 'Untangling earphones before a heavy set...';

  @override
  String get loadingJoke8 => 'Waiting for that guy to get off the machine...';

  @override
  String get loadingJoke9 =>
      'Trying to remember how many plates were on the bar...';

  @override
  String get loadingJoke10 => 'Taking a water break and moving on...';

  @override
  String get loadingJoke11 =>
      'Gathering strength for the perfect Romanian deadlift...';

  @override
  String get loadingJoke12 => 'Stretching fingers before saving...';

  @override
  String get loadingJoke13 => 'Mentally preparing for leg day...';

  @override
  String get customExerciseCategory => 'Custom Exercises';

  @override
  String get catLegs => 'Legs';

  @override
  String get catChest => 'Chest';

  @override
  String get catBack => 'Back';

  @override
  String get catShoulders => 'Shoulders';

  @override
  String get catArms => 'Arms';

  @override
  String get catAbs => 'Abs';

  @override
  String get catCardio => 'Cardio';

  @override
  String get catCalves => 'Calves';

  @override
  String get catFullBody => 'Full Body';

  @override
  String get eqBarbell => 'Barbell';

  @override
  String get eqDumbbell => 'Dumbbell';

  @override
  String get eqMachine => 'Machine';

  @override
  String get eqBodyweight => 'Bodyweight';

  @override
  String get eqBench => 'Bench';

  @override
  String get eqInclineBench => 'Incline bench';

  @override
  String get eqDeclineBench => 'Decline bench';

  @override
  String get eqPullUpBar => 'Pull-up bar';

  @override
  String get eqDipBar => 'Dip bars';

  @override
  String get eqMat => 'Gym mat';

  @override
  String get eqCable => 'Cable machine';

  @override
  String get eqKettlebell => 'Kettlebell';

  @override
  String get eqSmithMachine => 'Smith machine';

  @override
  String get eqEzBar => 'EZ-bar';

  @override
  String get eqRope => 'Rope attachment';

  @override
  String get eqRomanChair => 'Roman chair';

  @override
  String get eqPecDeck => 'Pec deck machine';

  @override
  String get eqTreadmill => 'Treadmill';

  @override
  String get eqElliptical => 'Elliptical';

  @override
  String get eqRowingMachine => 'Rowing machine';

  @override
  String get eqAbWheel => 'Ab wheel';

  @override
  String get eqWeightPlate => 'Weight plate';

  @override
  String get musQuads => 'Quadriceps';

  @override
  String get musGlutes => 'Glutes';

  @override
  String get musHamstrings => 'Hamstrings';

  @override
  String get musCalves => 'Calves';

  @override
  String get musSoleus => 'Soleus';

  @override
  String get musChest => 'Pectorals';

  @override
  String get musUpperChest => 'Upper chest';

  @override
  String get musLowerChest => 'Lower chest';

  @override
  String get musInnerChest => 'Inner chest';

  @override
  String get musLats => 'Lats';

  @override
  String get musMidBack => 'Mid back';

  @override
  String get musLowerBack => 'Lower back';

  @override
  String get musTraps => 'Trapezius';

  @override
  String get musFrontDelts => 'Front delts';

  @override
  String get musSideDelts => 'Side delts';

  @override
  String get musRearDelts => 'Rear delts';

  @override
  String get musBiceps => 'Biceps';

  @override
  String get musTriceps => 'Triceps';

  @override
  String get musForearms => 'Forearms';

  @override
  String get musBrachialis => 'Brachialis';

  @override
  String get musAbs => 'Abs';

  @override
  String get musLowerAbs => 'Lower abs';

  @override
  String get musObliques => 'Obliques';

  @override
  String get musCore => 'Core';

  @override
  String get musHeart => 'Heart';

  @override
  String get musHipFlexors => 'Hip flexors';

  @override
  String get musAbductors => 'Abductors';

  @override
  String get musAdductors => 'Adductors';

  @override
  String get musRotatorCuff => 'Rotator cuff';

  @override
  String get tipsSquat =>
      'Keep your back straight and look forward.\nSquat down until your thighs are parallel to the floor.\nPush through your heels on the way up.';

  @override
  String get tipsFrontSquat =>
      'Keep your elbows as high as possible.\nThe barbell should rest on your front deltoids.\nKeep your torso upright.';

  @override
  String get tipsGobletSquat =>
      'Hold the weight close to your chest.\nSquat deep, pushing your knees outward.';

  @override
  String get tipsSmithMachineSquat =>
      'Place your feet slightly forward to emphasize the glutes.\nLean back against the bar for support.';

  @override
  String get tipsHackSquat =>
      'Keep your back flat against the pad.\nDo not lift your heels off the platform.';

  @override
  String get tipsLunge =>
      'Take a wide enough step.\nYour back knee should almost touch the floor.\nKeep your front knee behind your toes.';

  @override
  String get tipsWalkingLunge =>
      'Maintain balance and do not rush.\nKeep your torso upright.';

  @override
  String get tipsReverseLunge =>
      'Stepping back reduces stress on the knee joints.\nPush off with your front leg to return.';

  @override
  String get tipsBulgarianSplitSquat =>
      'Place your rear foot on a bench.\nLean your torso slightly forward to target the glutes.';

  @override
  String get tipsLegPress =>
      'Do not fully lock your knees at the top of the movement.\nKeep your lower back pressed against the seat.';

  @override
  String get tipsWallSit =>
      'Keep a 90-degree angle at your knees.\nPress your entire back against the wall.';

  @override
  String get tipsLegExtension =>
      'Keep your hips firmly on the seat.\nControl the weight on the way down.';

  @override
  String get tipsLegCurl =>
      'Perform smooth, controlled movements.\nKeep your hips pressed against the pad.';

  @override
  String get tipsSeatedLegCurl =>
      'Secure the leg pads firmly.\nCurl your legs as far back as possible.';

  @override
  String get tipsDeadlift =>
      'Keep the bar as close to your shins as possible.\nInitiate the lift by pushing with your legs.\nKeep your back perfectly straight.';

  @override
  String get tipsSumoDeadlift =>
      'Take a very wide stance.\nKeep your torso more upright than in a conventional deadlift.';

  @override
  String get tipsRomanianDeadlift =>
      'Push your hips back as far as possible.\nKeep a slight bend in your knees.\nFeel the stretch in your hamstrings.';

  @override
  String get tipsGoodMorning =>
      'Rest the bar on your traps, similar to a squat.\nHinge at the hips, keeping your legs slightly bent.';

  @override
  String get tipsHipThrust =>
      'Rest your shoulder blades on the bench.\nPause at the top and squeeze your glutes.\nTuck your chin to your chest.';

  @override
  String get tipsGluteBridge =>
      'Drive through your heels.\nDo not hyperextend your lower back at the top.';

  @override
  String get tipsCablePullThrough =>
      'Face away from the machine.\nThe movement should come from hinging at the hips.';

  @override
  String get tipsStandingCalfRaise =>
      'Lower your heels as much as possible.\nRaise up on your toes as high as you can.';

  @override
  String get tipsSeatedCalfRaise =>
      'Sit up straight and secure the knee pads.\nMove slowly and with control.';

  @override
  String get tipsDonkeyCalfRaise =>
      'Keep your back straight while leaning forward.\nStretch your calves at the bottom of the movement.';

  @override
  String get tipsAbductorMachine =>
      'Push your legs apart in a smooth motion.\nControl the weight as you bring your legs back.';

  @override
  String get tipsAdductorMachine =>
      'Squeeze your legs together, feeling the inner thighs work.\nKeep your back pressed against the seat.';

  @override
  String get tipsBenchPress =>
      'Retract your shoulder blades and keep them down.\nKeep your feet firmly planted on the floor.\nLower the bar to your nipple line.';

  @override
  String get tipsInclineBenchPress =>
      'Set the bench angle to 30-45 degrees.\nLower the bar closer to your collarbones.';

  @override
  String get tipsDeclineBenchPress =>
      'Secure your legs under the pads.\nLower the bar to your lower chest.';

  @override
  String get tipsCloseGripBenchPress =>
      'Use a shoulder-width grip or slightly narrower.\nKeep your elbows tucked close to your body.';

  @override
  String get tipsSmithMachineBenchPress =>
      'Adjust the bench so the bar lowers to the middle of your chest.\nControl the descent.';

  @override
  String get tipsDumbbellBenchPress =>
      'Dumbbells allow for a deeper range of motion.\nBring the dumbbells together at the top, squeezing your chest.';

  @override
  String get tipsInclineDumbbellPress =>
      'Keep your elbows at about a 45-degree angle to your body.\nDo not drop the dumbbells quickly at the bottom.';

  @override
  String get tipsPushUp =>
      'Keep your body in a straight line.\nKeep your elbows tucked at a 45-degree angle.';

  @override
  String get tipsDiamondPushUp =>
      'Form a diamond shape with your index fingers and thumbs.\nLower your chest toward your hands.';

  @override
  String get tipsWeightedPushUp =>
      'Have a partner place a weight plate on your upper back.\nMaintain perfect form, do not let your lower back sag.';

  @override
  String get tipsDip =>
      'Lean forward slightly to emphasize the chest.\nDo not go down too deep to protect your shoulders.';

  @override
  String get tipsMachineFly =>
      'Keep your elbows slightly bent.\nSqueeze your chest muscles as you bring the handles together.';

  @override
  String get tipsCableCrossover =>
      'Lean forward slightly.\nThe movement should feel like \'hugging a tree\'.';

  @override
  String get tipsLowCableCrossover =>
      'Pull the handles from the bottom up.\nBring your hands together in front of your upper chest.';

  @override
  String get tipsDumbbellFly =>
      'Open your arms until you feel a mild stretch in your chest.\nDo not fully lock out your elbows.';

  @override
  String get tipsInclineDumbbellFly =>
      'Set the bench to a 30-degree angle.\nControl the movement, avoiding sudden jerks.';

  @override
  String get tipsPullover =>
      'Lie across or along the bench.\nLower the dumbbell behind your head with slightly bent arms.';

  @override
  String get tipsChestPressMachine =>
      'Adjust the seat so the handles are at chest level.\nPress evenly with both arms.';

  @override
  String get tipsPullUp =>
      'Start the pull by bringing your shoulder blades down.\nPull your chest toward the bar, not your chin.\nControl the descent, do not drop your body.';

  @override
  String get tipsChinUp =>
      'Use an underhand grip.\nKeep your elbows close to your body.';

  @override
  String get tipsLatPullDown =>
      'Do not lean back too far.\nPull the bar down to your upper chest.';

  @override
  String get tipsCloseGripLatPullDown =>
      'Squeeze your shoulder blades at the bottom.\nUse a narrow grip attachment.';

  @override
  String get tipsVBarPullDown =>
      'Pull the handle to your solar plexus.\nFeel the maximum contraction of your shoulder blades.';

  @override
  String get tipsBentOverRow =>
      'Lean your torso almost parallel to the floor.\nPull the bar to your waist, not your chest.';

  @override
  String get tipsReverseGripRow =>
      'An underhand grip helps keep elbows close to the body.\nControl the weight when lowering the barbell.';

  @override
  String get tipsSingleArmDumbbellRow =>
      'Support yourself with a knee and hand on a bench for stability.\nPull the dumbbell to your hip, not straight up.';

  @override
  String get tipsTBarRow =>
      'Maintain a natural arch in your lower back.\nDo not jerk the weight with your torso.';

  @override
  String get tipsSeatedCableRow =>
      'Sit up straight and avoid leaning back excessively.\nSqueeze your shoulder blades together at the end of the movement.';

  @override
  String get tipsMachineRow =>
      'Press your chest firmly against the pad.\nFocus on driving your elbows back.';

  @override
  String get tipsStraightArmPulldown =>
      'Keep your arms slightly bent but locked.\nThe movement should only occur at the shoulder joint.';

  @override
  String get tipsHyperextension =>
      'Do not hyperextend your back at the top.\nLower yourself slowly, feeling the stretch.';

  @override
  String get tipsRackPull =>
      'Set the barbell at knee height.\nPull the weight by extending your hips and back.';

  @override
  String get tipsOverheadPress =>
      'Squeeze your glutes and core to create a rigid base.\nThe bar should travel in a straight line close to your face.';

  @override
  String get tipsSeatedDumbbellPress =>
      'Sit on a bench with back support to stabilize your lower back.\nLower the dumbbells to ear level.';

  @override
  String get tipsSmithMachineShoulderPress =>
      'Adjust the bench so the bar lowers in front of your face.\nDo not fully lock out your elbows at the top.';

  @override
  String get tipsArnoldPress =>
      'At the bottom, your palms should face you.\nRotate your wrists as you press the dumbbells up.';

  @override
  String get tipsLateralRaise =>
      'Raise your arms as if you are pouring water from pitchers.\nDo not use momentum from your torso.';

  @override
  String get tipsCableLateralRaise =>
      'The cable provides constant tension.\nRun the cable behind your back or in front of you.';

  @override
  String get tipsMachineLateralRaise =>
      'Sit up straight and focus on raising your elbows.\nThe weight should be comfortable enough to maintain good form.';

  @override
  String get tipsFrontRaise =>
      'Raise your arms to eye level.\nAvoid swinging your torso.';

  @override
  String get tipsCableFrontRaise =>
      'Stand facing away from the machine and run the cable between your legs.\nKeep your elbows slightly bent.';

  @override
  String get tipsRearDeltRaise =>
      'Lean your torso parallel to the floor.\nFocus on squeezing the rear delts, not just your shoulder blades.';

  @override
  String get tipsReversePecDeck =>
      'Sit facing the machine.\nKeep your arms parallel to the floor.';

  @override
  String get tipsFacePull =>
      'Pull the rope to eye level.\nExternally rotate your arms at the end of the movement.';

  @override
  String get tipsUprightRow =>
      'Use a shoulder-width or slightly wider grip.\nPull your elbows higher than your hands.';

  @override
  String get tipsShoulderShrug =>
      'Simply raise your shoulders straight up toward your ears.\nDo not roll your shoulders.';

  @override
  String get tipsBicepsCurl =>
      'Keep your elbows tucked into your sides.\nAvoid swinging your torso.';

  @override
  String get tipsDumbbellCurl =>
      'You can perform this alternating arms.\nRotate your wrist (supinate) during the curl.';

  @override
  String get tipsHammerCurl =>
      'Hold the dumbbells with a neutral grip (palms facing each other).\nThe movement should be smooth and controlled.';

  @override
  String get tipsPreacherCurl =>
      'Press your triceps firmly against the pad.\nDo not fully extend your arms to protect your joints.';

  @override
  String get tipsConcentrationCurl =>
      'Rest your elbow on the inner part of your thigh.\nDo not use your shoulder or torso to assist.';

  @override
  String get tipsCableCurl =>
      'The cable creates constant tension in the muscle.\nTake a step back from the machine to increase the range of motion.';

  @override
  String get tipsZottmanCurl =>
      'Curl the dumbbells with an underhand grip (palms up).\nLower the dumbbells with an overhand grip (palms down).';

  @override
  String get tipsTricepsExtension =>
      'Can be performed with one or two hands.\nYour elbows should point straight up.';

  @override
  String get tipsSkullCrusher =>
      'Lower the bar behind your head or to your forehead.\nYour elbows should not flare out to the sides.';

  @override
  String get tipsTricepPushdown =>
      'Only your forearms should move.\nFully extend your arms at the bottom.';

  @override
  String get tipsRopePushdown =>
      'Pull the ends of the rope apart at the bottom.\nKeep your torso leaned slightly forward.';

  @override
  String get tipsOverheadCableExtension =>
      'Stand facing away from the cable machine.\nFully stretch the triceps by letting the rope go deep behind your head.';

  @override
  String get tipsTricepDipMachine =>
      'Sit up straight and press your back against the pad.\nPress the handles until your arms are fully extended.';

  @override
  String get tipsBenchDip =>
      'Keep your hips as close to the bench as possible.\nLower yourself until your elbows are at a 90-degree angle.';

  @override
  String get tipsCrunch =>
      'Do not lift your lower back off the floor.\nCrunch by bringing your ribs closer to your pelvis.';

  @override
  String get tipsCableCrunch =>
      'Kneel facing away from the machine.\nCrunch using your abs, do not pull with your arms.';

  @override
  String get tipsSitUp =>
      'You can anchor your feet.\nLift your entire torso until your chest touches your knees.';

  @override
  String get tipsLegRaise =>
      'Press your lower back into the floor.\nLower your legs slowly without letting your heels touch the ground.';

  @override
  String get tipsLegRaiseHang =>
      'Avoid swinging your body.\nTry to tilt your pelvis upward at the top of the movement.';

  @override
  String get tipsRussianTwist =>
      'Keep your back straight and lean back slightly.\nRotate your shoulders, not just your arms.';

  @override
  String get tipsPlank =>
      'Your body should form a straight line from head to heels.\nDo not lift your hips or let your lower back sag.';

  @override
  String get tipsSidePlank =>
      'Your elbow should be directly under your shoulder.\nDo not let your hips sag.';

  @override
  String get tipsAbWheelRollout =>
      'Keep your back slightly rounded and abs tight.\nDo not arch your lower back when fully extended.';

  @override
  String get tipsBicycleCrunch =>
      'Bring your right elbow to your left knee and vice versa.\nKeep your mouth open and breathe evenly.';

  @override
  String get tipsWoodchopper =>
      'Pull the cable diagonally from top to bottom.\nLock your hips and rotate only your upper torso.';

  @override
  String get tipsCardioTreadmill =>
      'Maintain good posture and do not slouch.\nTo increase intensity, raise the incline rather than just the speed.';

  @override
  String get tipsCardioElliptical =>
      'Use the handles to actively engage your upper body.\nKeep your heels on the pedals.';

  @override
  String get tipsCardioRowing =>
      'The movement consists of a leg drive followed by an arm pull.\nKeep your back straight throughout the movement.';

  @override
  String get tipsFarmerWalk =>
      'Keep your back perfectly straight and shoulders back.\nTake short, quick steps.';

  @override
  String get tipsKettlebellSwing =>
      'The momentum comes entirely from your hips (a hinge movement).\nDo not lift the kettlebell with your arms or shoulders.';
}
