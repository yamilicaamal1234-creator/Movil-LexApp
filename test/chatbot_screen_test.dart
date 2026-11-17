import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lexapp/core/theme/app_colors.dart';
import 'package:lexapp/screens/chatbot_screen.dart';
import 'package:lexapp/services/chatbot_service.dart';
import 'package:provider/provider.dart';

void main() {
  setUpAll(() {
    // Evita que google_fonts intente descargar fuentes durante los tests
    // (las peticiones HTTP fallan en el entorno de prueba).
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpChatbot(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ChatbotService(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ChatbotScreen(),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('muestra la bienvenida del asistente', (tester) async {
    await pumpChatbot(tester);

    expect(find.text('Asistente LexApp'), findsOneWidget);
    expect(find.text('Respuesta inmediata'), findsOneWidget);
    expect(
      find.textContaining('Asistente automatizado'),
      findsOneWidget,
    );
    expect(find.textContaining('Soy el asistente de LexApp'), findsOneWidget);
    expect(find.byIcon(Icons.smart_toy_rounded), findsWidgets);
  });

  testWidgets('las respuestas rápidas envían la consulta', (tester) async {
    await pumpChatbot(tester);

    await tester.tap(find.text('Consultar pagos'));
    await tester.pump();

    // El mensaje del usuario ya está en el hilo.
    expect(find.text('Consultar pagos'), findsWidgets);

    // Espera la respuesta simulada del servicio.
    await tester.pump(ChatbotService.replyDelay);
    await tester.pump();

    expect(find.textContaining('LX-2024-1182'), findsOneWidget);
    expect(find.textContaining('escribiendo'), findsNothing);
  });

  testWidgets('escribe y envía un mensaje manual', (tester) async {
    await pumpChatbot(tester);

    await tester.enterText(find.byType(TextField), '¿Cómo van mis casos?');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();

    expect(find.text('¿Cómo van mis casos?'), findsOneWidget);

    await tester.pump(ChatbotService.replyDelay);
    await tester.pump();
    expect(find.textContaining('2 casos activos'), findsOneWidget);
  });

  testWidgets('el botón de enviar está inactivo con el campo vacío', (
    tester,
  ) async {
    await pumpChatbot(tester);

    final sendButton = tester.widget<Container>(
      find.ancestor(
        of: find.byIcon(Icons.send_rounded),
        matching: find.byType(Container),
      ),
    );
    final decoration = sendButton.decoration! as BoxDecoration;
    expect(decoration.color, AppColors.slate);

    await tester.enterText(find.byType(TextField), 'hola');
    await tester.pump();

    final activeButton = tester.widget<Container>(
      find.ancestor(
        of: find.byIcon(Icons.send_rounded),
        matching: find.byType(Container),
      ),
    );
    final activeDecoration = activeButton.decoration! as BoxDecoration;
    expect(activeDecoration.color, AppColors.emerald);
  });

  testWidgets('reiniciar la conversación vuelve a la bienvenida', (
    tester,
  ) async {
    await pumpChatbot(tester);

    await tester.enterText(find.byType(TextField), 'hola');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump(ChatbotService.replyDelay);
    await tester.pump();
    expect(find.textContaining('¡Hola!'), findsWidgets);

    await tester.tap(find.byTooltip('Reiniciar conversación'));
    await tester.pump();

    final service = tester.element(find.byType(ChatbotScreen)).read<
      ChatbotService
    >();
    expect(service.messages, hasLength(1));
    expect(service.isTyping, isFalse);
  });
}
