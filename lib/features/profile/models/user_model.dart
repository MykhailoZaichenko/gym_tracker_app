class UserModel {
  // 1. Змінили тип на String, бо Firebase ID - це рядок
  final String? id;
  final String name;
  final String email;

  // Ці поля для Firebase Auth не потрібні (Firebase сам зберігає паролі безпечно),
  // але я залишив їх, щоб не ламати вашу логіку, якщо вони десь використовуються.
  final String? passwordHash;
  final String? salt;

  final String? avatarUrl;
  final double? weightKg;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.passwordHash,
    this.salt,
    this.avatarUrl,
    this.weightKg,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? passwordHash,
    String? salt,
    String? avatarUrl,
    double? weightKg,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      weightKg: weightKg ?? this.weightKg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      // Не зберігайте паролі в Firestore, якщо користуєтесь Firebase Auth!
      // 'passwordHash': passwordHash,
      // 'salt': salt,
      'avatarUrl': avatarUrl,
      'weightKg': weightKg,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> m) {
    return UserModel(
      // Безпечне приведення типів
      id: m['id'] as String? ?? '',
      name: m['name'] as String? ?? '',
      email: m['email'] as String? ?? '',
      passwordHash: m['passwordHash'] as String?,
      salt: m['salt'] as String?,
      avatarUrl: m['avatarUrl'] as String?,
      weightKg: (m['weightKg'] as num?)?.toDouble(),
    );
  }
}
