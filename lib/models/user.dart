class User {
  final int? id;
  final String email;
  final String name;
  final String passwordHash; // хеш пароля (sha256 + salt)
  final String salt; // унікальна сіль для кожного користувача
  final String? avatarUrl; // опціонально

  User({
    this.id,
    required this.email,
    required this.name,
    required this.passwordHash,
    required this.salt,
    this.avatarUrl,
  });

  User copyWith({
    int? id,
    String? email,
    String? name,
    String? passwordHash,
    String? salt,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'passwordHash': passwordHash,
      'salt': salt,
      'avatarUrl': avatarUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> m) {
    return User(
      id: m['id'] as int?,
      email: m['email'] as String,
      name: m['name'] as String,
      passwordHash: m['passwordHash'] as String,
      salt: m['salt'] as String,
      avatarUrl: m['avatarUrl'] as String?,
    );
  }
}
