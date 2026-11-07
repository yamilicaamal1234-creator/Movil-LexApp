import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              'assets/logo.png',
              width: 112,
              height: 112,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 18),
            const Text(
              'LexApp',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu Abogado al Alcance de un Clic',
              style: TextStyle(color: AppColors.white, fontSize: 15),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.fromLTRB(48, 0, 48, 42),
              child: LinearProgressIndicator(
                value: null,
                minHeight: 5,
                color: AppColors.emerald,
                backgroundColor: AppColors.border,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
