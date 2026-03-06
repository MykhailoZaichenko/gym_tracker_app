import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/pages/register_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/hero_widget.dart';
import 'package:gym_tracker_app/widget/common/page_title.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:gym_tracker_app/widget/common/style_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _weightCtrl = TextEditingController();

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _goToRegister() async {
    if (!_formKey.currentState!.validate()) return;

    // Якщо користувач ввів вагу
    if (_weightCtrl.text.trim().isNotEmpty) {
      final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));
      if (weight != null && weight > 0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('user_weight', weight);
      }
    } else {
      // Якщо поле пусте, просто очищаємо кеш (на випадок якщо там щось було)
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_weight');
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RegisterPage()),
    );
  }

  Future<void> _skipOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_weight');

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _skipOnboarding,
            child: Text(
              loc.skip,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                HeroWidget(tag: 'onboarding_lottie'),
                const SizedBox(height: 20),
                AppPageTitle(title: loc.onboardingTitle),
                const SizedBox(height: 20),
                StyledTextField(
                  controller: _weightCtrl,
                  labelText: loc.weightLabel,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    // 🔥 Тепер поле НЕ обов'язкове. Валідуємо тільки якщо щось введено
                    if (value == null || value.trim().isEmpty) return null;

                    final parsed = double.tryParse(value.replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) {
                      return loc.errWeightRequired;
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _goToRegister(),
                ),
                const SizedBox(height: 24),
                PrimaryFilledButton(
                  text: loc.continueAction,
                  onPressed: _goToRegister,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    loc.setLater,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
