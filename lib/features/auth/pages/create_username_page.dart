import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 🔥 Додано для форматування вводу
import 'package:gym_tracker_app/services/firestore_service.dart';

// 🔥 Спеціальний форматер, який автоматично робить літери малими і прибирає пробіли
class LowerCaseAndNoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase().replaceAll(' ', ''),
      selection: newValue.selection,
    );
  }
}

class CreateUsernamePage extends StatefulWidget {
  final VoidCallback onUsernameCreated;

  const CreateUsernamePage({super.key, required this.onUsernameCreated});

  @override
  State<CreateUsernamePage> createState() => _CreateUsernamePageState();
}

class _CreateUsernamePageState extends State<CreateUsernamePage> {
  final TextEditingController _usernameController = TextEditingController();
  final FirestoreService _firestore = FirestoreService();

  Timer? _debounce;
  bool _isChecking = false;
  bool _isAvailable = false;
  bool _isSaving = false;
  String _statusMessage = "Введіть нікнейм для пошуку друзів";
  Color _statusColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _prefillGoogleName();
  }

  void _prefillGoogleName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        user.displayName != null &&
        user.displayName!.isNotEmpty) {
      String suggested = user.displayName!.toLowerCase().replaceAll(' ', '_');
      suggested = suggested.replaceAll(RegExp(r'[^a-z0-9_]'), '');

      if (suggested.isNotEmpty) {
        _usernameController.text = suggested;
        _onUsernameChanged(suggested);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onUsernameChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    final cleanedValue = value.trim().toLowerCase();

    if (cleanedValue.isEmpty) {
      setState(() {
        _isChecking = false;
        _isAvailable = false;
        _statusMessage = "Нікнейм не може бути порожнім";
        _statusColor = Colors.red;
      });
      return;
    }

    if (cleanedValue.length < 3) {
      setState(() {
        _isChecking = false;
        _isAvailable = false;
        _statusMessage = "Мінімум 3 символи";
        _statusColor = Colors.red;
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _statusMessage = "Перевірка доступності...";
      _statusColor = Colors.blue;
    });

    _debounce = Timer(const Duration(milliseconds: 600), () async {
      final user = await _firestore.findUserByUsername(cleanedValue);

      if (!mounted) return;

      if (user == null) {
        setState(() {
          _isChecking = false;
          _isAvailable = true;
          _statusMessage = "Нікнейм вільний!";
          _statusColor = Colors.green;
        });
      } else {
        setState(() {
          _isChecking = false;
          _isAvailable = false;
          _statusMessage = "Цей нікнейм вже зайнятий";
          _statusColor = Colors.red;
        });
      }
    });
  }

  Future<void> _saveUsername() async {
    if (!_isAvailable || _isSaving) return;

    setState(() => _isSaving = true);

    final success = await _firestore.claimUsername(
      _usernameController.text.trim().toLowerCase(),
    );

    if (!mounted) return;

    if (success) {
      widget.onUsernameCreated();
    } else {
      setState(() {
        _isSaving = false;
        _isAvailable = false;
        _statusMessage = "Помилка збереження. Спробуйте інший нікнейм.";
        _statusColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ваш унікальний нікнейм"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.alternate_email,
              size: 64,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 24),
            const Text(
              "Оберіть собі нікнейм, щоб друзі могли легко знайти вас у спільноті Gym Tracker.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              onChanged: _onUsernameChanged,
              inputFormatters: [
                LowerCaseAndNoSpaceFormatter(), // 🔥 Автоматично робить малі літери та видаляє пробіли
              ],
              decoration: InputDecoration(
                labelText: "Нікнейм",
                prefixText: "@ ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _isChecking
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Дозволені лише малі літери (без пробілів).\nЦей нікнейм обирається назавжди і його неможливо буде змінити.",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _statusMessage,
              style: TextStyle(
                color: _statusColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isAvailable && !_isSaving ? _saveUsername : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Зберегти та продовжити",
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
