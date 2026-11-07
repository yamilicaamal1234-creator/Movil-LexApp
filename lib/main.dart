import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/chat_service.dart';
import 'services/app_data_service.dart';
import 'core/routes/app_routes.dart';

void main() => runApp(const LexApp());

class LexApp extends StatelessWidget {
  const LexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatService()),
        ChangeNotifierProvider(create: (_) => AppDataService()),
      ],
      child: MaterialApp(
        title: 'LexApp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
