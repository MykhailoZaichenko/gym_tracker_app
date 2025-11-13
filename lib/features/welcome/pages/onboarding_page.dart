import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/pages/register_page.dart';
import 'package:gym_tracker_app/widget/common/hero_widget.dart';
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

    final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.'));
    if (weight == null || weight <= 0) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('user_weight', weight);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage(title: 'Register')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                HeroWidget(tag: 'onboarding_lottie'),
                const SizedBox(height: 20),
                Text(
                  'Вкажіть вашу вагу для персоналізації',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _weightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Вага (кг)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final parsed = double.tryParse(value!.replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) {
                      return 'Введіть коректну вагу';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _goToRegister,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Продовжити'),
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
