import '../db/app_db.dart';
import '../models/user_model.dart';
import 'auth_utils.dart';

class AuthService {
  final AppDb _db = AppDb();

  // реєстрація (повертає створеного користувача або кидає Exception)
  Future<User> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final existing = await _db.getUserByEmail(email);
    if (existing != null) throw Exception('Користувач з таким email вже існує');

    final salt = generateSalt();
    final pwHash = hashPassword(password, salt);

    final user = User(
      email: email,
      name: name,
      passwordHash: pwHash,
      salt: salt,
    );
    return _db.createUser(user);
  }

  // автентифікація (повертає користувача або null)
  Future<User?> login({required String email, required String password}) async {
    final user = await _db.getUserByEmail(email);
    if (user == null) return null;
    final ok = verifyPassword(password, user.salt, user.passwordHash);
    return ok ? user : null;
  }

  // отримати поточного користувача по id
  Future<User?> getUser(int id) => _db.getUserById(id);

  // оновити профіль (наприклад, змінити ім'я або аватар)
  Future<int> updateProfile(User user) => _db.updateUser(user);

  // змінити пароль
  Future<void> changePassword(int userId, String newPassword) async {
    final user = await _db.getUserById(userId);
    if (user == null) throw Exception('Користувача не знайдено');
    final newSalt = generateSalt();
    final newHash = hashPassword(newPassword, newSalt);
    final updated = user.copyWith(passwordHash: newHash, salt: newSalt);
    await _db.updateUser(updated);
  }
}
