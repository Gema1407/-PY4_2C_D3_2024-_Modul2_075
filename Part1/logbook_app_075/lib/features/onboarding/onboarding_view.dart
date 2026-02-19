import 'package:flutter/material.dart';
import 'package:logbook_app_075/features/auth/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int step = 1;

  void _nextStep() {
    setState(() {
      step++;
      if (step > 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Step: $step', style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _nextStep, child: const Text('Next')),
          ],
        ),
      ),
    );
  }
}
