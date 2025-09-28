import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

// згенерувати соль
String generateSalt([int length = 16]) {
  final rand = Random.secure();
  final bytes = List<int>.generate(length, (_) => rand.nextInt(256));
  return base64Url.encode(bytes);
}

// хеш = SHA256(salt + password)
String hashPassword(String password, String salt) {
  final bytes = utf8.encode(salt + password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

// перевірка пароля
bool verifyPassword(String password, String salt, String hash) {
  return hashPassword(password, salt) == hash;
}
