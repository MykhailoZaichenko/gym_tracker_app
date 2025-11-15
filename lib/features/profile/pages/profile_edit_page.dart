import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:gym_tracker_app/widget/common/avatar_widget.dart';
import 'package:gym_tracker_app/widget/common/confirm_dialog.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:gym_tracker_app/widget/common/secondary_icon_text_button.dart';
import 'package:gym_tracker_app/widget/common/style_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/sources/local/app_db.dart';
import '../models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});

  final User user;

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

  String? _avatarPath; // локальний шлях у app dir або null
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

    _loadWeightFromPrefs();
  }

  Future<void> _loadWeightFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final localWeight = prefs.getDouble('user_weight');
    final fallbackWeight = widget.user.weightKg;

    final value = localWeight ?? fallbackWeight;
    if (value != null) {
      _weightCtrl.text = value.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Імʼя обовʼязкове';
    if (v.trim().length < 2) return 'Занадто коротке імʼя';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email обовʼязковий';
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(v.trim())) return 'Невірний email';
    return null;
  }

  String? _validateWeight(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final parsed = double.tryParse(v.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) return 'Вага повинна бути числом > 0';
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

      final newPath = await _copyFileToAppDir(
        picked.path,
        userId: widget.user.id,
      );
      if (newPath == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не вдалося зберегти фото локально')),
        );
        return;
      }

      // видалити старий файл, якщо він знаходився в папці avatars
      if (_avatarPath != null && _avatarPath != newPath) {
        try {
          final oldFile = File(_avatarPath!);
          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        } catch (_) {}
      }

      setState(() {
        _avatarPath = newPath;
      });
    } catch (e, st) {
      if (!mounted) return;
      debugPrint('Image pick error: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не вдалося відкрити галерею')),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Не вдалось вибрати фото: $e')));
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
      } catch (_) {
        // ігнорувати помилки видалення
      }
    }

    setState(() {
      _avatarPath = null;
    });
  }

  Future<void> _onSavePressed() async {
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
      await AppDb().updateUser(updatedUser);

      final prefs = await SharedPreferences.getInstance();
      if (updatedUser.id != null) {
        await prefs.setInt('current_user_id', updatedUser.id!);
      }
      if (weight != null && weight > 0) {
        await prefs.setDouble('user_weight', weight);
      }

      if (!mounted) return;
      Navigator.of(context).pop(updatedUser);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Помилка збереження: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редагувати профіль'),
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
                    'Зберегти',
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
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Видалити фото'),
                                content: const Text(
                                  'Ви дійсно хочете видалити фото?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: const Text('Ні'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(true),
                                    child: const Text('Так'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) await _removeAvatar();
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SecondaryIconTextButton(
                              label: 'Редагувати',
                              icon: Icons.edit,
                              variant: ButtonVariant.outlined,
                              isLoading: _isPickingAvatar,
                              onPressed: _pickAvatar,
                            ),
                            const SizedBox(width: 12),
                            if ((_avatarPath != null &&
                                    _avatarPath!.isNotEmpty) ||
                                (widget.user.avatarUrl != null &&
                                    widget.user.avatarUrl!.isNotEmpty))
                              SecondaryIconTextButton(
                                label: 'Видалити',
                                icon: Icons.delete_outline,
                                variant: ButtonVariant.destructive,
                                onPressed: () async {
                                  final confirmed =
                                      await showConfirmationDialog(
                                        context: context,
                                        title: 'Видалити фото',
                                        content:
                                            'Ви дійсно хочете видалити фото?',
                                      );
                                  if (confirmed == true) {
                                    await _removeAvatar();
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    StyledTextField(
                      controller: _nameCtrl,
                      labelText: 'Імʼя',
                      validator: _validateName,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    StyledTextField(
                      controller: _emailCtrl,
                      labelText: 'Email',
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    StyledTextField(
                      controller: _weightCtrl,
                      labelText: 'Вага (kg)',
                      validator: _validateWeight,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 25),
                    PrimaryFilledButton(
                      text: 'Зберегти',
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
