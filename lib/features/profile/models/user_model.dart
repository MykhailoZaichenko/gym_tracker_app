class UserModel {
  final String? id;
  final String name;
  final String email;

  final String? avatarUrl;
  final int weeklyGoal;

  final int currentStreak;
  final Map<String, double> monthlyBestWeights;
  final DateTime? lastWorkoutDate;
  final int workoutsThisMonth;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.weeklyGoal = 0,
    this.currentStreak = 0,
    this.monthlyBestWeights = const {},
    this.lastWorkoutDate,
    this.workoutsThisMonth = 0,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    int? weeklyGoal,
    int? currentStreak,
    Map<String, double>? monthlyBestWeights,
    DateTime? lastWorkoutDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentStreak: currentStreak ?? this.currentStreak,
      monthlyBestWeights: monthlyBestWeights ?? this.monthlyBestWeights,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'weeklyGoal': weeklyGoal,
      'currentStreak': currentStreak,
      'monthlyBestWeights': monthlyBestWeights,
      'lastWorkoutDate': lastWorkoutDate?.toIso8601String(),
      'workoutsThisMonth': workoutsThisMonth,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'],
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'] as String?,
      weeklyGoal: (data['weeklyGoal'] as num?)?.toInt() ?? 0,
      currentStreak: (data['currentStreak'] as num?)?.toInt() ?? 0,
      monthlyBestWeights:
          (data['monthlyBestWeights'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ) ??
          {},
      lastWorkoutDate: data['lastWorkoutDate'] != null
          ? DateTime.tryParse(data['lastWorkoutDate'])
          : null,
      workoutsThisMonth: (data['workoutsThisMonth'] as num?)?.toInt() ?? 0,
    );
  }
}
