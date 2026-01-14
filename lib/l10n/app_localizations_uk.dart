// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'Gym Tracker App';

  @override
  String get ok => 'ОК';

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get saved => 'Збережено';

  @override
  String get close => 'Закрити';

  @override
  String get discard => 'Не зберігати';

  @override
  String get edit => 'Редагувати';

  @override
  String get delete => 'Видалити';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get send => 'Надіслати';

  @override
  String get guest => 'Гість';

  @override
  String get getStarted => 'Почати';

  @override
  String get continueAction => 'Продовжити';

  @override
  String get onboardingTitle => 'Вкажіть вашу вагу для персоналізації';

  @override
  String get loginTitle => 'Ввійти в обліковий запис';

  @override
  String get registerTitle => 'Створити обліковий запис';

  @override
  String get registerAction => 'Зареєструватися';

  @override
  String get loginAction => 'Ввійти';

  @override
  String get forgotPassword => 'Забули пароль';

  @override
  String get alreadyHaveAccount => 'Вже є акаунт?';

  @override
  String get googleButton => 'Google';

  @override
  String get verifyEmailTitle => 'Підтвердження пошти';

  @override
  String get verifyEmailMessage =>
      'Лист із підтвердженням було надіслано на вашу електронну пошту. Будь ласка, перейдіть за посиланням у листі.';

  @override
  String get resendEmail => 'Надіслати лист ще раз';

  @override
  String get cancelLogout => 'Скасувати (Вийти)';

  @override
  String get resetPasswordTitle => 'Скидання паролю';

  @override
  String get resetPasswordInstruction =>
      'Введіть свій email. Ми надішлемо вам посилання для створення нового паролю.';

  @override
  String get resetPasswordEmailSent =>
      'Лист для скидання паролю надіслано! Перевірте пошту.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Введіть email';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get passwordHint => 'Введіть пароль';

  @override
  String get confirmPasswordLabel => 'Підтвердження паролю';

  @override
  String get confirmPasswordHint => 'Введіть пароль ще раз';

  @override
  String get nameLabel => 'Імʼя';

  @override
  String get nameHint => 'Введіть імʼя';

  @override
  String get weightLabel => 'Вага';

  @override
  String get repsLabel => 'Повт';

  @override
  String get errEmailRequired => 'Email обовʼязковий';

  @override
  String get errInvalidEmail => 'Невірний email';

  @override
  String get errPasswordRequired => 'Пароль обовʼязковий';

  @override
  String get errPasswordShort => 'Пароль має бути мінімум 6 символів';

  @override
  String get errPasswordsDoNotMatch => 'Паролі не співпадають';

  @override
  String get errNameRequired => 'Імʼя обовʼязкове';

  @override
  String get errNameShort => 'Занадто коротке імʼя';

  @override
  String get errWeightRequired => 'Введіть коректну вагу';

  @override
  String get errWeightInvalid => 'Вага повинна бути числом > 0';

  @override
  String get errGoogleSignIn => 'Помилка входу через Google';

  @override
  String get errInvalidCredentials => 'Невірний email або пароль';

  @override
  String get errLoginGeneral => 'Помилка входу';

  @override
  String get errUserNotFound => 'Користувача з такою поштою не знайдено';

  @override
  String get errWrongPassword => 'Невірний пароль';

  @override
  String get errEmailAlreadyInUse =>
      'Цей email вже використовується іншим акаунтом';

  @override
  String get errWeakPassword => 'Пароль занадто слабкий';

  @override
  String get errTooManyRequests => 'Забагато спроб. Спробуйте пізніше';

  @override
  String get errRequiresRecentLogin =>
      'Для цієї дії потрібно зайти в акаунт заново';

  @override
  String get errUnknown => 'Сталася невідома помилка';

  @override
  String saveError(String error) {
    return 'Помилка збереження: $error';
  }

  @override
  String get navHome => 'Головна';

  @override
  String get navJournal => 'Щоденник';

  @override
  String get navHistory => 'Історія';

  @override
  String get navStats => 'Статистика';

  @override
  String get navProfile => 'Профіль';

  @override
  String get calendarTitle => 'Календар тренувань';

  @override
  String get selectDay => 'Оберіть день';

  @override
  String get selectMonth => 'Оберіть місяць';

  @override
  String get pickMonthYear => 'Виберіть місяць і рік';

  @override
  String get prevYear => 'Попередній рік';

  @override
  String get nextYear => 'Наступний рік';

  @override
  String get backToToday => 'Сьогодні';

  @override
  String get exercisesFor => 'Вправи за';

  @override
  String get noExercisesToday => 'Немає вправ за цей день';

  @override
  String get workoutTitle => 'Тренування';

  @override
  String get startWorkout => 'Почати тренування';

  @override
  String get continueWorkout => 'Продовжити тренування';

  @override
  String get workoutToday => 'Тренування на сьогодні';

  @override
  String get noWorkoutToday => 'На сьогодні немає записів';

  @override
  String get saveChangesTitle => 'Зберегти зміни?';

  @override
  String get unsavedChangesMsg =>
      'Є незбережені зміни. Зберегти перед виходом?';

  @override
  String get synchronized => 'Синхронізовано';

  @override
  String get selectWorkoutType => 'Оберіть тип тренування';

  @override
  String get splitPush => 'Push (Жим)';

  @override
  String get splitPull => 'Pull (Тяга)';

  @override
  String get splitLegs => 'Ноги';

  @override
  String get splitUpper => 'Верх тіла';

  @override
  String get splitLower => 'Низ тіла';

  @override
  String get splitFullBody => 'Все тіло';

  @override
  String get splitCardio => 'Кардіо';

  @override
  String get splitCustom => 'Інше';

  @override
  String copyPreviousWorkout(String type) {
    return 'Скопіювати минуле тренування $type ';
  }

  @override
  String get addExerciseBtn => 'Додати вправу';

  @override
  String get addSetBtn => 'Додати підхід';

  @override
  String get setsLabel => 'Підходів';

  @override
  String get weightRepsLabel => 'Вага (kg·reps)';

  @override
  String get setLabelCompact => 'Підх';

  @override
  String setNumber(int number) {
    return 'Підхід $number';
  }

  @override
  String deleteSet(int number) {
    return 'Видалити підхід $number';
  }

  @override
  String setsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count підходів',
      many: '$count підходів',
      few: '$count підходи',
      one: '1 підхід',
    );
    return '$_temp0';
  }

  @override
  String exercisesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вправ',
      many: '$count вправ',
      few: '$count вправи',
      one: '1 вправа',
    );
    return '$_temp0';
  }

  @override
  String get weightUnit => 'кг';

  @override
  String get weightUnitHint => 'Кг';

  @override
  String get repsUnit => 'повт';

  @override
  String get repsUnitHint => 'Повт';

  @override
  String get calories => 'Калорії';

  @override
  String caloriesCount(String count) {
    return '$count ккал';
  }

  @override
  String get exerciseDefaultName => 'Вправа';

  @override
  String get enterCustomExerciseName => 'Введіть назву вправи';

  @override
  String get exerciseNameHint => 'Назва вправи';

  @override
  String get addExercise => 'Додати вправу';

  @override
  String get addExercisesHint =>
      'Додайте вправи у календарі, щоб бачити графік';

  @override
  String get selectExercise => 'Оберіть вправу';

  @override
  String get deleteExercise => 'Видалити вправу';

  @override
  String get searchExercise => 'Пошук вправи';

  @override
  String get enterCustomName => 'Ввести власну назву';

  @override
  String get addExerciseTooltip => 'Додати вправу';

  @override
  String get editExercisesTooltip => 'Редагувати вправи';

  @override
  String get chartsTitle => 'Прогрес — графіки';

  @override
  String get yourProgressFor => 'Ваш прогрес за';

  @override
  String get progressTooltip => 'Прогрес';

  @override
  String get exerciseLabel => 'Вправа:';

  @override
  String get chooseExercise => 'Оберіть вправу';

  @override
  String get tabMonth => 'Місяць';

  @override
  String get tabYear => 'Рік';

  @override
  String get noDataRange => 'Немає даних для вибраної вправи у цьому діапазоні';

  @override
  String get liftedWeight => 'Піднятий обсяг';

  @override
  String get liftedWeightHelp => 'Обсяг = Вага × Повтори';

  @override
  String get liftedWeightDescription => 'Опис формули';

  @override
  String get totalLifted => 'Всього піднято:';

  @override
  String get maxWeight => 'Макс. вага:';

  @override
  String get pointsCount => 'Точок:';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get editProfileTitle => 'Редагувати профіль';

  @override
  String get darkMode => 'Темний режим';

  @override
  String get lightMode => 'Світлий режим';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get appLanguage => 'Мова додатку';

  @override
  String get selectLanguage => 'Виберіть мову';

  @override
  String get languageUk => 'Українська';

  @override
  String get languageEn => 'English';

  @override
  String get aboutApp => 'Про додаток';

  @override
  String get appDescription => 'Додаток для відстеження ваших тренувань.';

  @override
  String get delPhoto => 'Видалити фото';

  @override
  String get deletePhotoTitle => 'Видалити фото';

  @override
  String get deletePhotoConfirm => 'Ви дійсно хочете видалити фото?';

  @override
  String get logoutAction => 'Вийти';

  @override
  String get logoutTitle => 'Вихід із профілю';

  @override
  String get logoutConfirm => 'Ви дійсно хочете вийти?';

  @override
  String get clearData => 'Очистити всі дані';

  @override
  String get clearDataConfirmTitle => 'Очистити всі дані';

  @override
  String get clearDataConfirmContent =>
      'Це видалить усі збережені тренування та налаштування. Продовжити?';

  @override
  String get dataClearedSuccess => 'Дані успішно очищені';

  @override
  String get deleteAccount => 'Видалити акаунт';

  @override
  String get deleteAccountTitle => 'Видалити акаунт?';

  @override
  String get deleteAccountWarning =>
      'Цю дію неможливо скасувати. Всі ваші дані (тренування, статистика, профіль) будуть втрачені назавжди.';

  @override
  String get securityUpdate => 'Вимога безпеки';

  @override
  String get reLoginRequiredMsg =>
      'З міркувань безпеки, будь ласка, вийдіть з акаунту та увійдіть знову перед видаленням.';

  @override
  String get exSquat => 'Присідання';

  @override
  String get exFrontSquat => 'Фронтальні присідання';

  @override
  String get exGobletSquat => 'Кубкові присідання';

  @override
  String get exLunge => 'Випади';

  @override
  String get exWalkingLunge => 'Випади в русі';

  @override
  String get exBulgarianSplitSquat => 'Болгарські випади';

  @override
  String get exLegPress => 'Жим ногами';

  @override
  String get exWallSit => 'Стільчик (біля стіни)';

  @override
  String get exLegExtension => 'Розгинання ніг';

  @override
  String get exLegCurl => 'Згинання ніг';

  @override
  String get exDeadlift => 'Станова тяга';

  @override
  String get exSumoDeadlift => 'Станова тяга сумо';

  @override
  String get exRomanianDeadlift => 'Румунська тяга';

  @override
  String get exGoodMorning => 'Гуд морнінг (Нахили)';

  @override
  String get exHipThrust => 'Сідничний місток (штанга)';

  @override
  String get exGluteBridge => 'Сідничний місток (підлога)';

  @override
  String get exStandingCalfRaise => 'Підйом на литки стоячи';

  @override
  String get exSeatedCalfRaise => 'Підйом на литки сидячи';

  @override
  String get exDonkeyCalfRaise => 'Підйом на литки \"віслюк\"';

  @override
  String get exAbductorMachine => 'Розведення ніг';

  @override
  String get exAdductorMachine => 'Зведення ніг';

  @override
  String get exBenchPress => 'Жим лежачи';

  @override
  String get exInclineBenchPress => 'Жим лежачи під кутом';

  @override
  String get exDeclineBenchPress => 'Жим лежачи головою вниз';

  @override
  String get exDumbbellBenchPress => 'Жим гантелей лежачи';

  @override
  String get exInclineDumbbellPress => 'Жим гантелей під кутом';

  @override
  String get exPushUp => 'Віджимання';

  @override
  String get exDiamondPushUp => 'Алмазні віджимання';

  @override
  String get exDip => 'Віджимання на брусах';

  @override
  String get exMachineFly => 'Метелик (Pec-Deck)';

  @override
  String get exCableCrossover => 'Кросовер';

  @override
  String get exDumbbellFly => 'Розведення гантелей';

  @override
  String get exPullover => 'Пуловер';

  @override
  String get exChestPressMachine => 'Жим в тренажері на груди';

  @override
  String get exPullUp => 'Підтягування';

  @override
  String get exChinUp => 'Підтягування зворотним хватом';

  @override
  String get exLatPullDown => 'Тяга верхнього блоку';

  @override
  String get exCloseGripLatPullDown => 'Тяга блоку вузьким хватом';

  @override
  String get exBentOverRow => 'Тяга штанги в нахилі';

  @override
  String get exReverseGripRow => 'Тяга штанги зворотним хватом';

  @override
  String get exSingleArmDumbbellRow => 'Тяга гантелі однією рукою';

  @override
  String get exTBarRow => 'Тяга Т-грифа';

  @override
  String get exSeatedCableRow => 'Горизонтальна тяга блоку';

  @override
  String get exMachineRow => 'Тяга важеля (в тренажері)';

  @override
  String get exStraightArmPulldown => 'Пуловер на блоці стоячи';

  @override
  String get exHyperextension => 'Гіперекстензія';

  @override
  String get exRackPull => 'Тяга з плінтів';

  @override
  String get exOverheadPress => 'Армійський жим';

  @override
  String get exSeatedDumbbellPress => 'Жим гантелей сидячи';

  @override
  String get exArnoldPress => 'Жим Арнольда';

  @override
  String get exLateralRaise => 'Махи гантелями в сторони';

  @override
  String get exCableLateralRaise => 'Махи в сторони на блоці';

  @override
  String get exFrontRaise => 'Підйом рук перед собою';

  @override
  String get exRearDeltRaise => 'Махи в нахилі (задня дельта)';

  @override
  String get exReversePecDeck => 'Зворотний метелик';

  @override
  String get exFacePull => 'Тяга до обличчя';

  @override
  String get exUprightRow => 'Тяга до підборіддя';

  @override
  String get exShoulderShrug => 'Шраги';

  @override
  String get exBicepsCurl => 'Підйом на біцепс';

  @override
  String get exDumbbellCurl => 'Підйом гантелей на біцепс';

  @override
  String get exHammerCurl => 'Молотки';

  @override
  String get exPreacherCurl => 'Згинання на лаві Скотта';

  @override
  String get exConcentrationCurl => 'Концентрований підйом';

  @override
  String get exCableCurl => 'Згинання рук на блоці';

  @override
  String get exZottmanCurl => 'Згинання Зоттмана';

  @override
  String get exTricepsExtension => 'Розгинання на трицепс (з-за голови)';

  @override
  String get exSkullCrusher => 'Французький жим лежачи';

  @override
  String get exTricepPushdown => 'Розгинання на блоці донизу';

  @override
  String get exTricepDipMachine => 'Віджимання в тренажері на трицепс';

  @override
  String get exBenchDip => 'Зворотні віджимання від лави';

  @override
  String get exCrunch => 'Скручування';

  @override
  String get exCableCrunch => 'Скручування на блоці (молитва)';

  @override
  String get exSitUp => 'Підйом тулуба';

  @override
  String get exLegRaise => 'Підйом ніг лежачи';

  @override
  String get exLegRaiseHang => 'Підйом ніг у висі';

  @override
  String get exRussianTwist => 'Російський твіст';

  @override
  String get exPlank => 'Планка';

  @override
  String get exSidePlank => 'Бокова планка';

  @override
  String get exAbWheelRollout => 'Ролик для преса';

  @override
  String get exBicycleCrunch => 'Велосипед';

  @override
  String get exWoodchopper => 'Лісоруб (на блоці)';

  @override
  String get exCardioTreadmill => 'Бігова доріжка';

  @override
  String get exCardioElliptical => 'Орбітрек';

  @override
  String get exCardioRowing => 'Гребний тренажер';

  @override
  String get exFarmerWalk => 'Прогулянка фермера';

  @override
  String get finishWorkout => 'Завершити тренування';

  @override
  String get workoutSummary => 'Підсумок тренування';

  @override
  String get durationLabel => 'Тривалість';

  @override
  String get noPreviousData => 'Немає даних для порівняння';

  @override
  String get greatJob => 'Чудова робота!';

  @override
  String get viewLastReport => 'Останній звіт';

  @override
  String copyLastWorkout(String type) {
    return 'Скопійовано з останнього $type тренування';
  }

  @override
  String get comparisonTitle => 'Порівняння за місяць';

  @override
  String get startValue => 'Початкове значення';

  @override
  String get currentValue => 'Поточне значення';

  @override
  String get difference => 'Різниця';

  @override
  String get notificationsEnabledTitle => 'Сповіщення увімкнено! 🔔';

  @override
  String get notificationsEnabledBody =>
      'Тепер ви будете отримувати нагадування.';

  @override
  String get weightControl => 'Контроль ваги';

  @override
  String get weightChartAndReminders => 'Графік ваги та нагадування';

  @override
  String get healthTitle => 'Здоровʼя';

  @override
  String get weightChangeLabel => 'Зміна ваги';

  @override
  String get gymSessions => 'Сесії в залі';

  @override
  String get reminderSettings => 'Налаштування нагадувань';

  @override
  String get frequency => 'Частота';

  @override
  String get daily => 'Щодня';

  @override
  String get weekly => 'Щотижня';

  @override
  String get selectTime => 'Оберіть час';

  @override
  String reminderSet(String time) {
    return 'Нагадування встановлено: $time';
  }

  @override
  String get editWeight => 'Редагувати вагу';

  @override
  String get addWeight => 'Додати вагу';

  @override
  String weightDateRange(String start, String end) {
    return 'Зміна з $start по $end';
  }

  @override
  String get saveSettings => 'Зберегти налаштування';

  @override
  String get history => 'Історія';

  @override
  String get weightHistory => 'Історія ваги';
}
