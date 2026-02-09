class UserModel {
  // 1. Змінили тип на String, бо Firebase ID - це рядок
  final String? id;
  final String name;
  final String email;

  final String? avatarUrl;
  final double? weightKg;
  final int weeklyGoal;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.weightKg,
    this.weeklyGoal = 0,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    double? weightKg,
    int? weeklyGoal,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      weightKg: weightKg ?? this.weightKg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'weightKg': weightKg,
      'weeklyGoal': weeklyGoal,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> m) {
    return UserModel(
      // Безпечне приведення типів
      id: m['id'] as String? ?? '',
      name: m['name'] as String? ?? '',
      email: m['email'] as String? ?? '',
      avatarUrl: m['avatarUrl'] as String?,
      weightKg: (m['weightKg'] as num?)?.toDouble(),
      weeklyGoal: (m['weeklyGoal'] as num?)?.toInt() ?? 0,
    );
  }
}
