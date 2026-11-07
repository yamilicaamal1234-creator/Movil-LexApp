import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexapp/main.dart';
import 'package:lexapp/screens/main_screen.dart';
import 'package:lexapp/services/app_data_service.dart';
import 'package:lexapp/services/chat_service.dart';
import 'package:provider/provider.dart';

void main() {
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
