import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/pages/create_new_password_page.dart';
import 'package:gym_tracker_app/features/auth/pages/login_page.dart';
import 'package:gym_tracker_app/features/welcome/pages/onboarding_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/hero_widget.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    final appLinks = AppLinks();

    try {
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint("Помилка отримання стартового посилання: $e");
    }

    _linkSubscription = appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    Uri targetUri = uri;

    if (uri.queryParameters.containsKey('link')) {
      targetUri = Uri.parse(uri.queryParameters['link']!);
    }

    if (targetUri.queryParameters.containsKey('oobCode') &&
        targetUri.queryParameters['mode'] == 'resetPassword') {
      final oobCode = targetUri.queryParameters['oobCode']!;

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNewPasswordPage(oobCode: oobCode),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroWidget(tag: 'welcome_lottie'),
              FittedBox(
                child: Text(
                  loc.appName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 500.0,
                    letterSpacing: 50.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              PrimaryFilledButton(
                text: loc.getStarted,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingPage(),
                    ),
                    (route) => false,
                  );
                },
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginPage();
                      },
                    ),
                    (route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(loc.loginAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
