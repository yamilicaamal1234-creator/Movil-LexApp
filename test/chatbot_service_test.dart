import 'package:flutter_test/flutter_test.dart';
import 'package:lexapp/models/chatbot_message.dart';
import 'package:lexapp/services/chatbot_service.dart';

void main() {
  group('ChatbotService', () {
    late ChatbotService service;

    setUp(() => service = ChatbotService());
    tearDown(() => service.dispose());

    /// Envía [text] y espera la respuesta simulada del asistente.
    Future<ChatbotMessage> replyTo(String text) async {
      expect(service.send(text), isTrue);
      await Future<void>.delayed(ChatbotService.replyDelay);
      return service.messages.last;
    }

    test('arranca con un mensaje de bienvenida del bot', () {
      expect(service.messages, hasLength(1));
      expect(service.messages.single.sender, ChatbotSender.bot);
      expect(service.messages.single.suggestions, isNotEmpty);
      expect(service.isTyping, isFalse);
    });

    test('responde con reglas de casos, documentos y pagos', () async {
      expect((await replyTo('¿Cómo van mis casos?')).text, contains('2 casos'));
      expect(
        (await replyTo('Necesito el contrato')).text,
        contains('pendiente de firma'),
      );
      expect((await replyTo('¿Cuánto cuesta?')).text, contains('LX-2024-1182'));
    });

    test('normaliza tildes, mayúsculas y puntuación', () async {
      expect((await replyTo('HOLA!!!')).text, contains('asistente de LexApp'));
      expect((await replyTo('¿CuántO cuesta?')).text, contains('métodos'));
    });

    test('las respuestas rápidas disparan la regla correspondiente', () async {
      for (final suggestion in const [
        'Ver mis casos',
        'Consultar pagos',
        'Agendar una cita',
        'Firmar un documento',
      ]) {
        final reply = await replyTo(suggestion);
        expect(reply.sender, ChatbotSender.bot, reason: suggestion);
      }
    });

    test('cae en la respuesta genérica cuando no hay coincidencia', () async {
      expect((await replyTo('zzz qwerty')).text, contains('No estoy seguro'));
    });

    test('rechaza correos y teléfonos sin agregar el mensaje', () {
      expect(service.send('escríbeme a juan@correo.com'), isFalse);
      expect(service.warning, isNotNull);
      expect(service.messages, hasLength(1));

      service.clearWarning();
      expect(service.warning, isNull);

      expect(service.send('mi teléfono es 5512345678'), isFalse);
      expect(service.warning, isNotNull);
      expect(service.messages, hasLength(1));
    });

    test('ignora mensajes vacíos', () {
      expect(service.send('   '), isFalse);
      expect(service.messages, hasLength(1));
    });

    test('marca "escribiendo" hasta que llega la respuesta', () async {
      expect(service.send('hola'), isTrue);
      expect(service.isTyping, isTrue);
      expect(service.messages, hasLength(2));

      await Future<void>.delayed(ChatbotService.replyDelay);
      expect(service.isTyping, isFalse);
      expect(service.messages, hasLength(3));
      expect(service.messages.last.sender, ChatbotSender.bot);
    });

    test('reset devuelve el hilo a la bienvenida y cancela la respuesta', () {
      service.send('¿Cómo van mis casos?');
      service.reset();

      expect(service.isTyping, isFalse);
      expect(service.messages, hasLength(1));
      expect(service.messages.single.sender, ChatbotSender.bot);
      expect(service.warning, isNull);
    });

    test('el etiquetado de escalamiento tiene regla propia', () async {
      expect(ChatbotService.escalateLabel, 'Hablar con un abogado');
      // La pantalla intercepta esta etiqueta antes de llamar a `send`; aquí
      // verificamos que, si llegara al servicio, produce una respuesta.
      final reply = await replyTo(ChatbotService.escalateLabel);
      expect(reply.sender, ChatbotSender.bot);
    });

    test('las respuestas siempre incluyen la hora', () async {
      final reply = await replyTo('hola');
      expect(reply.time, matches(RegExp(r'^\d{1,2}:\d{2} (AM|PM)$')));
    });

    test('las listas expuestas son de solo lectura', () {
      expect(
        () => service.messages.add(
          const ChatbotMessage(
            text: 'x',
            sender: ChatbotSender.user,
            time: '0:00 AM',
          ),
        ),
        throwsUnsupportedError,
      );
      expect(service.messages, hasLength(1));
    });
  });
}
