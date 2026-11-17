/// Quién envía un mensaje dentro de la conversación con el asistente.
enum ChatbotSender { bot, user }

/// Mensaje de la conversación con el asistente estático de LexApp.
class ChatbotMessage {
  const ChatbotMessage({
    required this.text,
    required this.sender,
    required this.time,
    this.suggestions = const <String>[],
  });

  final String text;
  final ChatbotSender sender;
  final String time;

  /// Respuestas rápidas ofrecidas junto a este mensaje.
  ///
  /// Solo se muestran cuando este es el último mensaje del hilo; en cuanto el
  /// usuario responde, dejan de estar disponibles.
  final List<String> suggestions;
}
