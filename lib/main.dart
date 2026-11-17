import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_controller.dart';
import 'screens/splash_screen.dart';
import 'services/chat_service.dart';
import 'services/chatbot_service.dart';
import 'services/app_data_service.dart';
import 'core/routes/app_routes.dart';
import 'core/network/api_client.dart';
import 'services/backend_repository.dart';
import 'services/api_service.dart';

void main() => runApp(const LexApp());

class LexApp extends StatelessWidget {
  const LexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModeController()),
        Provider<ApiClient>(create: (_) => ApiClient()),
        ProxyProvider<ApiClient, BackendRepository>(
          update: (_, api, __) => BackendRepository(api),
        ),
        ChangeNotifierProvider(create: (_) => ChatService()),
        ChangeNotifierProvider(create: (_) => ChatbotService()),
        ChangeNotifierProvider(create: (_) => AppDataService()),
        Provider<ApiService>(create: (_) => ApiService()),
      ],
      child: Consumer<ThemeModeController>(
        builder: (context, themeController, _) => MaterialApp(
          title: 'LexApp',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.themeMode,
          home: const SplashScreen(),
          onGenerateRoute: AppRoutes.generateRoute,
          builder: (context, child) =>
              _ThemeSync(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}

/// Sincroniza [AppColors.isDark] con el brillo real del tema (incluido el
/// modo "sistema" del teléfono) y fuerza el repintado de todas las pantallas
/// abiertas cuando cambia.
class _ThemeSync extends StatelessWidget {
  const _ThemeSync({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (AppColors.isDark != dark) {
      AppColors.isDark = dark;
      final root = context as Element;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!root.mounted) return;
        void rebuild(Element e) {
          e.markNeedsBuild();
          e.visitChildren(rebuild);
        }
        root.visitChildren(rebuild);
      });
    }
    return child;
  }
}
