import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexapp/core/theme/app_theme.dart';
import 'package:lexapp/core/theme/theme_mode_controller.dart';
import 'package:lexapp/main.dart';
import 'package:lexapp/screens/main_screen.dart';
import 'package:lexapp/services/app_data_service.dart';
import 'package:lexapp/services/chat_service.dart';
import 'package:provider/provider.dart';

void main() {
  test('LexApp themes use semantic colors for both brightness modes', () {
    expect(AppTheme.light.scaffoldBackgroundColor, const Color(0xFFF8FAFC));
    expect(AppTheme.light.cardColor, Colors.white);
    expect(AppTheme.light.colorScheme.primary, const Color(0xFF00B87B));
    expect(AppTheme.dark.scaffoldBackgroundColor, const Color(0xFF071324));
    expect(AppTheme.dark.cardColor, const Color(0xFF112240));
    expect(AppTheme.dark.colorScheme.primary, const Color(0xFF00B87B));
  });

  testWidgets('LexApp dashboard renders', (tester) async {
    await tester.pumpWidget(const LexApp());
    await tester.pump(const Duration(milliseconds: 2100));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenido a LexApp'), findsOneWidget);

    await tester.pumpWidget(const LexApp());
    await tester.pump();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeModeController()),
          ChangeNotifierProvider(create: (_) => ChatService()),
          ChangeNotifierProvider(create: (_) => AppDataService()),
        ],
        child: const MaterialApp(home: MainScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Hola, Ricardo'), findsOneWidget);
    expect(find.text('Buscar abogado'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
  });
}
