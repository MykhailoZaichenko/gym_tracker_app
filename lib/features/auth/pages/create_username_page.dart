import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';

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

// 🔥 Enum для безпечної локалізації статусу
enum UsernameStatus { idle, empty, short, checking, available, taken, error }

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
  UsernameStatus _status = UsernameStatus.idle;

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
        _status = UsernameStatus.empty;
      });
      return;
    }

    if (cleanedValue.length < 3) {
      setState(() {
        _isChecking = false;
        _isAvailable = false;
        _status = UsernameStatus.short;
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _status = UsernameStatus.checking;
    });

    _debounce = Timer(const Duration(milliseconds: 600), () async {
      final isAvailable = await _firestore.isUsernameAvailable(cleanedValue);
      if (!mounted) return;

      setState(() {
        _isChecking = false;
        _isAvailable = isAvailable;
        _status = isAvailable ? UsernameStatus.available : UsernameStatus.taken;
      });
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
        _status = UsernameStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // Конвертація статусу в текст
    String statusMessage;
    Color statusColor;
    switch (_status) {
      case UsernameStatus.idle:
        statusMessage = loc.enterUsernameHint;
        statusColor = Colors.grey;
        break;
      case UsernameStatus.empty:
        statusMessage = loc.usernameEmptyError;
        statusColor = Colors.red;
        break;
      case UsernameStatus.short:
        statusMessage = loc.usernameTooShortError;
        statusColor = Colors.red;
        break;
      case UsernameStatus.checking:
        statusMessage = loc.usernameChecking;
        statusColor = Colors.blue;
        break;
      case UsernameStatus.available:
        statusMessage = loc.usernameAvailable;
        statusColor = Colors.green;
        break;
      case UsernameStatus.taken:
        statusMessage = loc.usernameTaken;
        statusColor = Colors.red;
        break;
      case UsernameStatus.error:
        statusMessage = loc.usernameSaveError;
        statusColor = Colors.red;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.uniqueUsernameTitle),
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
            Text(
              loc.chooseUsernameDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              onChanged: _onUsernameChanged,
              inputFormatters: [LowerCaseAndNoSpaceFormatter()],
              decoration: InputDecoration(
                labelText: loc.usernameLabel,
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
            Text(
              loc.usernameRulesDesc,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              statusMessage,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
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
                  : Text(
                      loc.saveAndContinue,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
