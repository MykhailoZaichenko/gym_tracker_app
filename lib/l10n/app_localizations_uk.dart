// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'Gym Tracker';

  @override
  String get ok => 'ОК';

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
  String get yourProgressFor => 'Ваша активність за';

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
  String get themeSelectionTitle => 'Тема додатку';

  @override
  String get darkMode => 'Темний режим';

  @override
  String get lightMode => 'Світлий режим';

  @override
  String get systemMode => 'Системний режим';

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
  String get exSmithMachineSquat => 'Присідання в Сміті';

  @override
  String get exHackSquat => 'Гакк-присідання';

  @override
  String get exReverseLunge => 'Зворотні випади';

  @override
  String get exSeatedLegCurl => 'Згинання ніг сидячи';

  @override
  String get exCablePullThrough => 'Тяга блоку між ногами';

  @override
  String get exCloseGripBenchPress => 'Жим вузьким хватом';

  @override
  String get exSmithMachineBenchPress => 'Жим лежачи в Сміті';

  @override
  String get exWeightedPushUp => 'Віджимання з вагою';

  @override
  String get exLowCableCrossover => 'Кросовер з нижнього блоку';

  @override
  String get exInclineDumbbellFly => 'Розведення гантелей під кутом';

  @override
  String get exVBarPullDown => 'Тяга верхнього блоку (V-руків\'я)';

  @override
  String get exSmithMachineShoulderPress => 'Жим сидячи в Сміті';

  @override
  String get exMachineLateralRaise => 'Махи в сторони (тренажер)';

  @override
  String get exCableFrontRaise => 'Підйом рук перед собою на блоці';

  @override
  String get exRopePushdown => 'Розгинання з канатом донизу';

  @override
  String get exOverheadCableExtension => 'Розгинання з-за голови на блоці';

  @override
  String get exKettlebellSwing => 'Махи гирею';

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

  @override
  String get weeklyGoalTitle => 'Тижнева ціль';

  @override
  String get weeklyGoalQuestion =>
      'Скільки разів на тиждень ви плануєте тренуватися?';

  @override
  String get timesPerWeek => 'Разів/Тиждень';

  @override
  String streakWeeks(int count) {
    return '$count-тижнева серія';
  }

  @override
  String get streakKeep => 'Чудово! Виконали план на цей тиждень.';

  @override
  String streakBurn(int count) {
    return 'Тренуйтесь ще $count р., щоб зберегти серію!';
  }

  @override
  String get streakLostMsg => 'Серію втрачено. Почніть нову цього тижня!';

  @override
  String get weekLabel => 'Тиждень';

  @override
  String goalLabel(int count) {
    return 'Ціль змінено на $count разів/тиждень';
  }

  @override
  String get skip => 'Пропустити';

  @override
  String get setLater => 'Вказати пізніше';

  @override
  String get weightNotSet => 'Не вказано';

  @override
  String get weightMissingBanner =>
      'Вкажіть свою вагу, щоб ми могли розраховувати спалені калорії!';

  @override
  String get nextExercise => 'Наступна вправа';

  @override
  String get friendRequestSent =>
      'Запит у друзі через посилання успішно надіслано!';

  @override
  String additionError(String error) {
    return 'Помилка додавання: $error';
  }

  @override
  String get enterUsernameHint => 'Введіть нікнейм для пошуку друзів';

  @override
  String get usernameEmptyError => 'Нікнейм не може бути порожнім';

  @override
  String get usernameTooShortError => 'Мінімум 3 символи';

  @override
  String get usernameChecking => 'Перевірка доступності...';

  @override
  String get usernameAvailable => 'Нікнейм вільний!';

  @override
  String get usernameTaken => 'Цей нікнейм вже зайнятий';

  @override
  String get usernameSaveError =>
      'Помилка збереження. Спробуйте інший нікнейм.';

  @override
  String get uniqueUsernameTitle => 'Ваш унікальний нікнейм';

  @override
  String get chooseUsernameDesc =>
      'Оберіть собі нікнейм, щоб друзі могли легко знайти вас у спільноті Gym Tracker.';

  @override
  String get usernameLabel => 'Нікнейм';

  @override
  String get usernameRulesDesc =>
      'Дозволені лише малі літери (без пробілів).\nЦей нікнейм обирається назавжди і його неможливо буде змінити.';

  @override
  String get saveAndContinue => 'Зберегти та продовжити';

  @override
  String get weightReminderTitle => 'Нагадування про вагу ⚖️';

  @override
  String get weightReminderBody =>
      'Регулярний запис ваги допомагає точніше відстежувати прогрес. Хочете налаштувати нагадування, щоб не забувати це робити?';

  @override
  String get noThanks => 'Ні, дякую';

  @override
  String get yesSetUp => 'Так, налаштувати';

  @override
  String get permissionBlocked =>
      'Дозвіл заблоковано. Будь ласка, увімкніть сповіщення в налаштуваннях телефону.';

  @override
  String get settingsAction => 'Налаштування';

  @override
  String get unknownStatus => 'Невідомо';

  @override
  String lastSeenInGym(String date) {
    return 'Був(ла) у залі: $date';
  }

  @override
  String get statWeight => 'Вага';

  @override
  String get statStreak => 'Серія';

  @override
  String statWeeks(String count) {
    return '$count тиж.';
  }

  @override
  String get statPerMonth => 'За місяць';

  @override
  String statWorkouts(String count) {
    return '$count тр.';
  }

  @override
  String get recordsThisMonth => '🏆 Рекорди цього місяця';

  @override
  String get noRecordsThisMonth =>
      'Поки немає записів про рекорди цього місяця 😔';

  @override
  String get deleteFriendTitle => 'Видалення з друзів';

  @override
  String deleteFriendConfirmBody(String name) {
    return 'Ви впевнені, що хочете видалити $name зі списку друзів?';
  }

  @override
  String get cancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String friendDeletedSuccess(String name) {
    return '$name видалено з друзів';
  }

  @override
  String deleteError(String error) {
    return 'Помилка видалення: $error';
  }

  @override
  String get friendsAndCommunity => 'Друзі та Спільнота';

  @override
  String get myFriendsTab => 'Мої друзі';

  @override
  String get searchRequestsTab => 'Пошук / Запити';

  @override
  String get noFriendsYet => 'У вас поки немає друзів';

  @override
  String get findFriendBtn => 'Знайти друга';

  @override
  String get longTimeAgo => 'Давно';

  @override
  String get noRecords => 'Немає рекордів';

  @override
  String get monthlyRecordPrefix => 'Рекорд місяця: ';

  @override
  String get shareProfileLink => 'Поділитися посиланням на профіль';

  @override
  String get orFindManually => 'Або знайдіть вручну';

  @override
  String get searchFriendHint => 'Введіть Email або @нікнейм';

  @override
  String get searchFriendHelper => 'example@gmail.com або @gymbro';

  @override
  String get addBtn => 'Додати';

  @override
  String get incomingRequests => 'Вхідні запити';

  @override
  String get noNewRequests => 'Немає нових запитів';

  @override
  String shareFriendText(String link) {
    return 'Привіт! Додавай мене в друзі у Gym Tracker, щоб слідкувати за моїми тренуваннями: $link';
  }

  @override
  String get shareFriendSubject => 'Запит у друзі Gym Tracker';

  @override
  String requestSentTo(String email) {
    return 'Запит надіслано до $email!';
  }

  @override
  String get userNotFound => 'Користувача не знайдено';

  @override
  String get cannotAddSelf => 'Ви не можете додати самого себе';

  @override
  String get userDataError => 'Помилка даних користувача';

  @override
  String get requestSentSuccess => 'Запит надіслано!';

  @override
  String get previousPeriod => 'Минулий період';

  @override
  String get enableNotificationsTitle => 'Увімкнути сповіщення? 🔔';

  @override
  String get enableNotificationsBody =>
      'Це дозволить нам надсилати тобі нагадування про тренування та відстеження ваги, щоб ти не втрачав прогрес.';

  @override
  String errorPickingPhoto(String error) {
    return 'Помилка вибору фото: $error';
  }

  @override
  String get defaultUser => 'Користувач';

  @override
  String get friendsLabel => 'Друзі';

  @override
  String get communityLabel => 'Спільнота';

  @override
  String get inGymLabel => 'У залі';

  @override
  String get hoursShort => 'г';

  @override
  String get minutesShort => 'хв';

  @override
  String get avarageTimeLabel => 'Середній час';

  @override
  String get personalRecordsTitle => 'Особисті рекорди';

  @override
  String get oneRepMaxShort => '1ПМ';

  @override
  String get oneRepMaxTooltip =>
      'Оцінка максимальної ваги, яку ви можете підняти за одну повторювання, базуючись на вашому історії тренувань.';

  @override
  String get cardioMin => 'Хв';

  @override
  String get cardioKm => 'Км';

  @override
  String get bodyweightAddWeight => '+ Вага';

  @override
  String get recoverAccessTitle => 'Відновити доступ';

  @override
  String get createNewPasswordTitle => 'Створити новий пароль';

  @override
  String get createNewPasswordSubtitle =>
      'Створіть надійний пароль з принаймні 6 символами.';

  @override
  String get newPasswordLabel => 'Новий пароль';

  @override
  String get errPleaseEnterPassword => 'Будь ласка, введіть пароль';

  @override
  String get errPleaseConfirmPassword => 'Будь ласка, підтвердьте ваш пароль';

  @override
  String get savePasswordAction => 'Зберегти пароль';

  @override
  String get passwordChangedSuccess =>
      'Пароль успішно змінено! Тепер ви можете увійти.';

  @override
  String get errorPrefix => 'Помилка';

  @override
  String get systemLanguage => 'Як у системі';

  @override
  String get streakWarningTitle => 'Твій стрік у небезпеці! 🔥';

  @override
  String get streakWarningBody =>
      'Ти ще не тренувався сьогодні. Зроби коротку розминку, щоб зберегти вогник!';

  @override
  String get loadingJoke1 => 'Шукаємо вільну лаву для жиму...';

  @override
  String get loadingJoke2 => 'Вигадуємо відмазку, щоб не робити кардіо...';

  @override
  String get loadingJoke3 => 'Переконуємо твої м\'язи, що це ще не кінець...';

  @override
  String get loadingJoke4 =>
      'Рахуємо, скільки разів ти сказав «останній підхід»...';

  @override
  String get loadingJoke5 => 'Додаємо +5 кг до твоєї самооцінки...';

  @override
  String get loadingJoke6 => 'Шукаємо твою мотивацію під гантелями...';

  @override
  String get loadingJoke7 => 'Розплутуємо навушники перед важким сетом...';

  @override
  String get loadingJoke8 => 'Чекаємо, поки той хлопець звільнить тренажер...';

  @override
  String get loadingJoke9 =>
      'Намагаємось згадати, скільки млинців було на штанзі...';

  @override
  String get loadingJoke10 => 'П\'ємо водичку і продовжуємо...';

  @override
  String get loadingJoke11 => 'Збираємо сили для ідеальної румунської тяги...';

  @override
  String get loadingJoke12 =>
      'Робимо розтяжку для пальців перед збереженням...';

  @override
  String get loadingJoke13 => 'Морально готуємось до дня ніг...';

  @override
  String get customExerciseCategory => 'Користувацькі вправи';

  @override
  String get catLegs => 'Ноги';

  @override
  String get catChest => 'Груди';

  @override
  String get catBack => 'Спина';

  @override
  String get catShoulders => 'Плечі';

  @override
  String get catArms => 'Руки';

  @override
  String get catAbs => 'Прес';

  @override
  String get catCardio => 'Кардіо';

  @override
  String get catCalves => 'Ікри';

  @override
  String get catFullBody => 'Все тіло';

  @override
  String get eqBarbell => 'Штанга';

  @override
  String get eqDumbbell => 'Гантелі';

  @override
  String get eqMachine => 'Тренажер';

  @override
  String get eqBodyweight => 'Власна вага';

  @override
  String get eqBench => 'Лавка';

  @override
  String get eqInclineBench => 'Похила лавка';

  @override
  String get eqDeclineBench => 'Лавка зі схилом';

  @override
  String get eqPullUpBar => 'Перекладина';

  @override
  String get eqDipBar => 'Бруси';

  @override
  String get eqMat => 'Килимок';

  @override
  String get eqCable => 'Кросовер';

  @override
  String get eqKettlebell => 'Гиря';

  @override
  String get eqSmithMachine => 'Тренажер Сміта';

  @override
  String get eqEzBar => 'EZ-штанга';

  @override
  String get eqRope => 'Канат';

  @override
  String get eqRomanChair => 'Римський стілець';

  @override
  String get eqPecDeck => 'Тренажер метелик';

  @override
  String get eqTreadmill => 'Бігова доріжка';

  @override
  String get eqElliptical => 'Орбітрек';

  @override
  String get eqRowingMachine => 'Гребний тренажер';

  @override
  String get eqAbWheel => 'Гімнастичне колесо';

  @override
  String get eqWeightPlate => 'Диск (млинець)';

  @override
  String get musQuads => 'Квадрицепси';

  @override
  String get musGlutes => 'Сідниці';

  @override
  String get musHamstrings => 'Біцепс стегна';

  @override
  String get musCalves => 'Литки';

  @override
  String get musSoleus => 'Камбалоподібний м\'яз';

  @override
  String get musChest => 'Грудні';

  @override
  String get musUpperChest => 'Верхні грудні';

  @override
  String get musLowerChest => 'Нижні грудні';

  @override
  String get musInnerChest => 'Внутрішня частина грудних';

  @override
  String get musLats => 'Найширші';

  @override
  String get musMidBack => 'Середина спини';

  @override
  String get musLowerBack => 'Розгиначі спини';

  @override
  String get musTraps => 'Трапеції';

  @override
  String get musFrontDelts => 'Передні дельти';

  @override
  String get musSideDelts => 'Середні дельти';

  @override
  String get musRearDelts => 'Задні дельти';

  @override
  String get musBiceps => 'Біцепси';

  @override
  String get musTriceps => 'Трицепси';

  @override
  String get musForearms => 'Передпліччя';

  @override
  String get musBrachialis => 'Брахіаліс';

  @override
  String get musAbs => 'Прес';

  @override
  String get musLowerAbs => 'Прес (нижня частина)';

  @override
  String get musObliques => 'Косі м\'язи живота';

  @override
  String get musCore => 'М\'язи кору';

  @override
  String get musHeart => 'Серце';

  @override
  String get musHipFlexors => 'Згиначі стегна';

  @override
  String get musAbductors => 'Відвідні м\'язи';

  @override
  String get musAdductors => 'Привідні м\'язи стегна';

  @override
  String get musRotatorCuff => 'Обертальна манжета';

  @override
  String get tipsSquat =>
      'Тримай спину рівною, а погляд вперед.\nОпускайся до паралелі стегон з підлогою.\nВпирайся в п\'яти під час підйому.';

  @override
  String get tipsFrontSquat =>
      'Тримай лікті максимально високо.\nШтанга має лежати на передніх дельтах.\nТримай корпус вертикально.';

  @override
  String get tipsGobletSquat =>
      'Притисни вагу до грудей.\nОпускайся глибоко, розводячи коліна в сторони.';

  @override
  String get tipsSmithMachineSquat =>
      'Постав ноги трохи вперед для акценту на сідниці.\nСпирайся спиною на гриф.';

  @override
  String get tipsHackSquat =>
      'Щільно притисни спину до спинки.\nНе відривай п\'яти від платформи.';

  @override
  String get tipsLunge =>
      'Роби крок достатньої ширини.\nКоліно задньої ноги має майже торкатися підлоги.\nКоліно передньої ноги не повинно виходити за носок.';

  @override
  String get tipsWalkingLunge =>
      'Зберігай баланс і не поспішай.\nТримай корпус рівно.';

  @override
  String get tipsReverseLunge =>
      'Крок назад знімає навантаження з колінних суглобів.\nВідштовхуйся передньою ногою для повернення.';

  @override
  String get tipsBulgarianSplitSquat =>
      'Поклади задню ногу на лавку.\nДля акценту на сідниці нахили корпус трохи вперед.';

  @override
  String get tipsLegPress =>
      'Не випрямляй коліна до кінця у верхній точці (не блокуй суглоб).\nПритисни поперек до сидіння.';

  @override
  String get tipsWallSit =>
      'Кут у колінах має бути 90 градусів.\nПритисни всю спину до стіни.';

  @override
  String get tipsLegExtension =>
      'Зафіксуй таз у сидінні.\nКонтролюй вагу при опусканні.';

  @override
  String get tipsLegCurl =>
      'Рухи мають бути плавними.\nНе відривай таз від лавки.';

  @override
  String get tipsSeatedLegCurl =>
      'Добре зафіксуй валики на ногах.\nЗгинай ноги максимально сильно.';

  @override
  String get tipsDeadlift =>
      'Тримай гриф максимально близько до гомілок.\nПочинай рух відштовхуванням ніг.\nСпина має бути ідеально рівною.';

  @override
  String get tipsSumoDeadlift =>
      'Постав ноги максимально широко.\nТримай спину вертикальніше, ніж при класичній тязі.';

  @override
  String get tipsRomanianDeadlift =>
      'Відводь таз максимально назад.\nНоги злегка зігнуті в колінах.\nВідчуй розтягнення задньої поверхні стегна.';

  @override
  String get tipsGoodMorning =>
      'Штанга лежить на трапеціях, як при присіданнях.\nНахиляйся вперед, відводячи таз назад.';

  @override
  String get tipsHipThrust =>
      'Опирайся лопатками на лавку.\nУ верхній точці роби паузу та стискай сідниці.\nПідборіддя притисни до грудей.';

  @override
  String get tipsGluteBridge =>
      'Відштовхуйся п\'ятами.\nНе перерозгинай поперек у верхній точці.';

  @override
  String get tipsCablePullThrough =>
      'Стань спиною до тренажера.\nРух має відбуватися за рахунок тазостегнового суглоба.';

  @override
  String get tipsStandingCalfRaise =>
      'Опускай п\'яти максимально низько.\nПіднімайся на носки якомога вище.';

  @override
  String get tipsSeatedCalfRaise =>
      'Сядь рівно, зафіксуй валики на колінах.\nРухайся повільно та підконтрольно.';

  @override
  String get tipsDonkeyCalfRaise =>
      'Тримай спину рівною, нахилившись вперед.\nРозтягуй ікри в нижній точці.';

  @override
  String get tipsAbductorMachine =>
      'Розводь ноги плавним зусиллям.\nНе кидай вагу при зведенні.';

  @override
  String get tipsAdductorMachine =>
      'Зводь ноги, відчуваючи роботу внутрішньої частини стегна.\nТримай спину притиснутою.';

  @override
  String get tipsBenchPress =>
      'Зведи лопатки разом і опусти їх.\nСтупні жорстко впираються в підлогу.\nОпускай штангу на рівень сосків.';

  @override
  String get tipsInclineBenchPress =>
      'Кут лавки має бути 30-45 градусів.\nОпускай штангу ближче до ключиць.';

  @override
  String get tipsDeclineBenchPress =>
      'Зафіксуй ноги у валиках.\nОпускай штангу на низ грудей.';

  @override
  String get tipsCloseGripBenchPress =>
      'Хват на ширині плечей або трохи вужче.\nТримай лікті ближче до тулуба.';

  @override
  String get tipsSmithMachineBenchPress =>
      'Вистав лавку так, щоб гриф опускався на середину грудей.\nКонтролюй рух вниз.';

  @override
  String get tipsDumbbellBenchPress =>
      'Гантелі дозволяють опускати вагу нижче, ніж штангу.\nЗводь гантелі у верхній точці, стискаючи груди.';

  @override
  String get tipsInclineDumbbellPress =>
      'Зберігай кут ліктів близько 45 градусів до тіла.\nНе кидай гантелі в нижній точці.';

  @override
  String get tipsPushUp =>
      'Тіло має утворювати пряму лінію.\nЛікті спрямовані назад під кутом 45 градусів.';

  @override
  String get tipsDiamondPushUp =>
      'Постав руки так, щоб вказівні та великі пальці утворили ромб.\nОпускайся грудьми до рук.';

  @override
  String get tipsWeightedPushUp =>
      'Попроси партнера покласти диск на спину (в ділянці лопаток).\nЗберігай ідеальну техніку, не прогинай поперек.';

  @override
  String get tipsDip =>
      'Для акценту на груди нахили корпус вперед.\nНе опускайся занадто глибоко.';

  @override
  String get tipsMachineFly =>
      'Тримай лікті злегка зігнутими.\nСтискай грудні м\'язи у фазі зведення рук.';

  @override
  String get tipsCableCrossover =>
      'Злегка нахилися вперед.\nРух має нагадувати \"обійми дерева\".';

  @override
  String get tipsLowCableCrossover =>
      'Тягни рукоятки знизу вгору.\nЗводь руки перед грудьми.';

  @override
  String get tipsDumbbellFly =>
      'Розводь руки в сторони до легкого розтягування грудей.\nНе випрямляй лікті повністю.';

  @override
  String get tipsInclineDumbbellFly =>
      'Кут лавки 30 градусів.\nКонтролюй рух, уникаючи різких ривків.';

  @override
  String get tipsPullover =>
      'Ляж поперек лавки або вздовж.\nОпускай гантель за голову на злегка зігнутих руках.';

  @override
  String get tipsChestPressMachine =>
      'Відрегулюй сидіння так, щоб рукоятки були на рівні грудей.\nТискай рівномірно обома руками.';

  @override
  String get tipsPullUp =>
      'Починай тягу зі зведення лопаток донизу.\nТягнися грудьми до перекладини, а не підборіддям.\nКонтролюй фазу опускання, не кидай тіло вниз.';

  @override
  String get tipsChinUp =>
      'Використовуй зворотний хват.\nТримай лікті ближче до тулуба.';

  @override
  String get tipsLatPullDown =>
      'Не відхиляйся занадто сильно назад.\nТягни рукоятку до верхньої частини грудей.';

  @override
  String get tipsCloseGripLatPullDown =>
      'Зводь лопатки в нижній точці.\nВикористовуй вузьку рукоятку.';

  @override
  String get tipsVBarPullDown =>
      'Тягни рукоятку до сонячного сплетіння.\nВідчуй максимальне скорочення лопаток.';

  @override
  String get tipsBentOverRow =>
      'Нахили корпус майже паралельно до підлоги.\nТягни штангу до пояса, а не до грудей.';

  @override
  String get tipsReverseGripRow =>
      'Хват знизу допомагає тримати лікті ближче до тіла.\nКонтролюй вагу при опусканні штанги.';

  @override
  String get tipsSingleArmDumbbellRow =>
      'Спирайся коліном і рукою на лавку для стабільності.\nТягни гантель до тазостегнового суглоба, а не вгору.';

  @override
  String get tipsTBarRow =>
      'Зберігай природний прогин у попереку.\nНе смикай вагу корпусом.';

  @override
  String get tipsSeatedCableRow =>
      'Сядь рівно і не відхиляйся сильно назад.\nЗводь лопатки разом у кінцевій точці.';

  @override
  String get tipsMachineRow =>
      'Щільно притисни груди до подушки.\nКонцентруйся на роботі ліктями.';

  @override
  String get tipsStraightArmPulldown =>
      'Тримай руки злегка зігнутими, але зафіксованими.\nРух має відбуватися виключно в плечовому суглобі.';

  @override
  String get tipsHyperextension =>
      'Не перерозгинай спину у верхній точці.\nОпускайся повільно, розтягуючи м\'язи.';

  @override
  String get tipsRackPull =>
      'Встанови штангу на рівні колін.\nТягни вагу за рахунок випрямлення таза та спини.';

  @override
  String get tipsOverheadPress =>
      'Напружи сідниці та прес для створення жорсткого корсета.\nГриф має рухатися по прямій лінії максимально близько до обличчя.';

  @override
  String get tipsSeatedDumbbellPress =>
      'Сядь на лавку зі спинкою для стабілізації попереку.\nОпускай гантелі до рівня вух.';

  @override
  String get tipsSmithMachineShoulderPress =>
      'Відрегулюй лавку так, щоб гриф опускався перед обличчям.\nНе випрямляй лікті повністю у верхній точці.';

  @override
  String get tipsArnoldPress =>
      'У нижній точці долоні дивляться на тебе.\nПовертай кисті під час витискання гантелей вгору.';

  @override
  String get tipsLateralRaise =>
      'Піднімай руки так, наче виливаєш воду з глеків.\nНе закидай вагу корпусом.';

  @override
  String get tipsCableLateralRaise =>
      'Кабель забезпечує постійне натягнення.\nПроводь трос за спиною або перед собою.';

  @override
  String get tipsMachineLateralRaise =>
      'Сиди рівно, фокусуйся на піднятті ліктів.\nВага має бути комфортною для правильної техніки.';

  @override
  String get tipsFrontRaise =>
      'Піднімай руки до рівня очей.\nУникай розгойдування тулуба.';

  @override
  String get tipsCableFrontRaise =>
      'Встань спиною до блоку і пропусти трос між ногами.\nЗберігай лікті злегка зігнутими.';

  @override
  String get tipsRearDeltRaise =>
      'Нахили корпус паралельно підлозі.\nРозводь руки, концентруючись на зведенні задніх дельт, а не лопаток.';

  @override
  String get tipsReversePecDeck =>
      'Сядь обличчям до тренажера.\nТримай руки паралельно підлозі.';

  @override
  String get tipsFacePull =>
      'Тягни канат до рівня очей.\nУ кінцевій точці розводь руки в сторони.';

  @override
  String get tipsUprightRow =>
      'Використовуй хват на ширині плечей або ширше.\nТягни лікті вище рівня кистей.';

  @override
  String get tipsShoulderShrug =>
      'Просто піднімай плечі вгору до вух.\nНе роби обертових рухів плечима.';

  @override
  String get tipsBicepsCurl =>
      'Тримай лікті притиснутими до боків.\nУникай розгойдування корпусом.';

  @override
  String get tipsDumbbellCurl =>
      'Можна виконувати по черзі кожною рукою.\nПовертай кисть (супінація) під час підйому.';

  @override
  String get tipsHammerCurl =>
      'Тримай гантелі нейтральним хватом (долоні дивляться одна на одну).\nРух має бути плавним і підконтрольним.';

  @override
  String get tipsPreacherCurl =>
      'Щільно притисни трицепси до парти.\nНе випрямляй руки повністю, щоб не розірвати зв\'язки.';

  @override
  String get tipsConcentrationCurl =>
      'Упрись ліктем у внутрішню частину стегна.\nНе допомагай собі плечем або тулубом.';

  @override
  String get tipsCableCurl =>
      'Трос створює постійну напругу в м\'язі.\nКрок назад від тренажера допоможе збільшити амплітуду.';

  @override
  String get tipsZottmanCurl =>
      'Піднімай гантелі звичайним хватом (долоні вгору).\nОпускай гантелі зворотним хватом (долоні вниз).';

  @override
  String get tipsTricepsExtension =>
      'Можна виконувати однією або двома руками.\nЛікті мають бути спрямовані вгору.';

  @override
  String get tipsSkullCrusher =>
      'Опускай штангу за голову або до чола.\nЛікті не повинні розходитися в сторони.';

  @override
  String get tipsTricepPushdown =>
      'Тільки передпліччя мають рухатись.\nРозгинай руки повністю в нижній точці.';

  @override
  String get tipsRopePushdown =>
      'Розводь кінці канату в різні сторони у нижній точці.\nТримай корпус злегка нахиленим вперед.';

  @override
  String get tipsOverheadCableExtension =>
      'Встань спиною до блоку.\nРозтягуй трицепс повністю, опускаючи канат глибоко за голову.';

  @override
  String get tipsTricepDipMachine =>
      'Сядь рівно, притисни спину.\nТисни ручки до повного випрямлення рук.';

  @override
  String get tipsBenchDip =>
      'Тримай таз максимально близько до лавки.\nОпускайся до кута 90 градусів у ліктях.';

  @override
  String get tipsCrunch =>
      'Не відривай поперек від підлоги.\nСкручуйся, зближуючи ребра та таз.';

  @override
  String get tipsCableCrunch =>
      'Стань на коліна спиною до блоку.\nЗгинайся за рахунок преса, не тягни руками.';

  @override
  String get tipsSitUp =>
      'Можна зафіксувати стопи.\nПіднімай весь корпус, торкаючись грудьми колін.';

  @override
  String get tipsLegRaise =>
      'Притисни поперек до підлоги.\nОпускай ноги повільно, не торкаючись п\'ятами землі.';

  @override
  String get tipsLegRaiseHang =>
      'Уникай розгойдування тіла.\nНамагайся підкручувати таз вгору в кінцевій точці.';

  @override
  String get tipsRussianTwist =>
      'Тримай спину рівною, злегка відхилившись назад.\nПовертай плечі, а не лише руки.';

  @override
  String get tipsPlank =>
      'Тіло має бути прямою лінією від голови до п\'ят.\nНе задирай таз та не прогинай поперек.';

  @override
  String get tipsSidePlank =>
      'Лікоть має знаходитися рівно під плечем.\nНе дозволяй тазу провисати вниз.';

  @override
  String get tipsAbWheelRollout =>
      'Тримай спину злегка скругленою, напруживши прес.\nНе прогинай поперек при витягуванні.';

  @override
  String get tipsBicycleCrunch =>
      'Тягнися правим ліктем до лівого коліна і навпаки.\nРот має бути відкритим, дихай рівно.';

  @override
  String get tipsWoodchopper =>
      'Тягни трос по діагоналі зверху вниз.\nЗафіксуй стегна, обертай тільки верхньою частиною тулуба.';

  @override
  String get tipsCardioTreadmill =>
      'Зберігай правильну поставу, не сутулься.\nДля більшого навантаження збільшуй кут нахилу, а не лише швидкість.';

  @override
  String get tipsCardioElliptical =>
      'Використовуй ручки, щоб активно залучати верхню частину тіла.\nТримай п\'яти на педалях.';

  @override
  String get tipsCardioRowing =>
      'Рух складається з поштовху ногами, а потім тяги руками.\nЗберігай спину рівною протягом всього руху.';

  @override
  String get tipsFarmerWalk =>
      'Тримай спину ідеально рівною, розправ плечі.\nРоби невеликі швидкі кроки.';

  @override
  String get tipsKettlebellSwing =>
      'Імпульс іде виключно від тазу (рух \"назад-вперед\").\nНе піднімай гирю силою рук або плечей.';
}
