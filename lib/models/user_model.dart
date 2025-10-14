// lib/models/user_model.dart
class User {
  final int? id;
  final String name;
  final String email;
  final String passwordHash;
  final String salt;
  final String? avatarUrl; // шлях в файловій системі або null
  final double? weightKg;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.salt,
    this.avatarUrl,
    this.weightKg,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? passwordHash,
    String? salt,
    String? avatarUrl,
    double? weightKg,
  }) {
    return User(
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
      'passwordHash': passwordHash,
      'salt': salt,
      'avatarUrl': avatarUrl,
      'weightKg': weightKg,
    };
  }

  factory User.fromMap(Map<String, dynamic> m) {
    return User(
      id: m['id'] as int?,
      name: m['name'] as String? ?? '',
      email: m['email'] as String? ?? '',
      passwordHash: m['passwordHash'] as String? ?? '',
      salt: m['salt'] as String? ?? '',
      avatarUrl: m['avatarUrl'] as String?,
      weightKg: (m['weightKg'] as num?)?.toDouble(),
    );
  }
}
