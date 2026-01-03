import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';

import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/widget/common/avatar_widget.dart';
import 'package:gym_tracker_app/widget/common/confirm_dialog.dart';
import 'package:gym_tracker_app/widget/common/custome_snackbar.dart';

import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:gym_tracker_app/widget/common/style_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _weightCtrl;
  bool _saving = false;
  bool _isPickingAvatar = false;

  final FirestoreService _firestore = FirestoreService();

  String? _avatarPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _emailCtrl = TextEditingController(text: widget.user.email);
    _weightCtrl = TextEditingController(
      text: widget.user.weightKg?.toString() ?? '',
    );
    _avatarPath = widget.user.avatarUrl;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    final loc = AppLocalizations.of(context)!;
    if (v == null || v.trim().isEmpty) return loc.errNameRequired;
    if (v.trim().length < 2) return loc.errNameShort;
    return null;
  }

  String? _validateEmail(String? v) {
    final loc = AppLocalizations.of(context)!;
    if (v == null || v.trim().isEmpty) return loc.errEmailRequired;
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(v.trim())) return loc.errInvalidEmail;
    return null;
  }

  String? _validateWeight(String? v) {
    final loc = AppLocalizations.of(context)!;
    if (v == null || v.trim().isEmpty) return null;
    final parsed = double.tryParse(v.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) return loc.errWeightInvalid;
    return null;
  }

  Future<Directory> _appDir() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir;
  }

  Future<String?> _copyFileToAppDir(String sourcePath, {int? userId}) async {
    try {
      final src = File(sourcePath);
      if (!await src.exists()) return null;
      final appDir = await _appDir();
      final safeName =
          '${userId ?? 'anon'}_${DateTime.now().millisecondsSinceEpoch}${p.extension(sourcePath)}';
      final destPath = p.join(appDir.path, 'avatars');
      final destDir = Directory(destPath);
      if (!await destDir.exists()) await destDir.create(recursive: true);
      final destFile = File(p.join(destPath, safeName));
      final copied = await src.copy(destFile.path);
      return copied.path;
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickAvatar() async {
    if (_isPickingAvatar) return;
    _isPickingAvatar = true;
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;

      final newPath = await _copyFileToAppDir(picked.path);
      if (newPath == null) return;

      setState(() {
        _avatarPath = newPath;
      });
    } catch (e) {
      debugPrint('Image pick error: $e');
    } finally {
      _isPickingAvatar = false;
    }
  }

  Future<void> _removeAvatar() async {
    if (_avatarPath != null) {
      try {
        final file = File(_avatarPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}
    }
    setState(() {
      _avatarPath = null;
    });
  }

  Future<void> _onSavePressed() async {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));

    final updatedUser = widget.user.copyWith(
      name: name,
      email: email,
      weightKg: weight,
      avatarUrl: _avatarPath,
    );

    try {
      await _firestore.saveUser(updatedUser);

      if (!mounted) return;
      Navigator.of(context).pop(updatedUser);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      CustomSnackBar.show(
        context,
        message: loc.saveError(e.toString()),
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.editProfileTitle),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saving ? null : _onSavePressed,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    loc.save,
                    style: TextStyle(
                      color: ThemeService.isDarkModeNotifier.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      children: [
                        AvatarWidget(
                          name: _nameCtrl.text,
                          avatarPath: _avatarPath ?? widget.user.avatarUrl,
                          radius: 80,
                          onEditPressed: _pickAvatar,
                          onDeletePressed: () async {
                            final confirmed = await showConfirmationDialog(
                              context: context,
                              title: loc.deletePhotoTitle,
                              content: loc.deletePhotoConfirm,
                              confirmText: loc.yes,
                              cancelText: loc.no,
                            );
                            if (confirmed == true) await _removeAvatar();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    StyledTextField(
                      controller: _nameCtrl,
                      labelText: loc.nameLabel,
                      validator: _validateName,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    StyledTextField(
                      controller: _emailCtrl,
                      labelText: loc.emailLabel,
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    StyledTextField(
                      controller: _weightCtrl,
                      labelText: loc.weightLabel,
                      validator: _validateWeight,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 25),
                    PrimaryFilledButton(
                      text: loc.save,
                      isLoading: _saving,
                      onPressed: _onSavePressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
