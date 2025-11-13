import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/pages/login_page.dart';
import 'package:gym_tracker_app/features/welcome/pages/onboarding_page.dart';
import 'package:gym_tracker_app/widget/common/hero_widget.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const OnboardingPage();
                      },
                    ),
                    (route) => false,
                  );
                },
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.0),
                ),
                child: const Text("Get Started"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginPage(title: "Log in");
                      },
                    ),
                    (route) => false,
                  );
                },
                child: const Text("Log In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:gym_tracker_app/features/auth/pages/auth_page.dart';

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({Key? key}) : super(key: key);

//   void _navigateToAuth(BuildContext context) {
//     Navigator.of(
//       context,
//     ).push(MaterialPageRoute(builder: (_) => const AuthPage()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blueAccent, Colors.purpleAccent],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               backgroundColor: Colors.white,
//             ),
//             onPressed: () => _navigateToAuth(context),
//             child: const Text(
//               'Get Started',
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
