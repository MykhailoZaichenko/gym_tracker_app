import 'package:flutter/material.dart';
import 'package:gym_tracker_app/views/pages/login_page.dart';
import 'package:gym_tracker_app/views/pages/onboarding_page.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // HeroWidget(),
                isDark
                    // У темному режимі — біла анімація
                    ? ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcATop,
                        ),
                        child: Lottie.asset(
                          'assets/lotties/dumbell.json',
                          height: 400,
                        ),
                      )
                    // В світлому режимі — без фільтра (оригінальні кольори)
                    : Lottie.asset('assets/lotties/dumbell.json', height: 400),
                FittedBox(
                  child: Text(
                    "Gym Tracker",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 500.0,
                      letterSpacing: 50.0,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const OnboardingPage();
                        },
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 50.0),
                  ),
                  child: const Text("Get Started"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginPage(title: 'Log in');
                        },
                      ),
                    );
                  },
                  child: const Text("Log In"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
