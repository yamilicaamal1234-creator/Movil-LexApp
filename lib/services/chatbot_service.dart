import 'dart:async';

import 'package:flutter/material.dart';

import '../core/validators/contact_validator.dart';
import '../models/chatbot_message.dart';

/// Regla de respuesta del asistente: si el mensaje del usuario contiene
/// cualquiera de sus [keywords], se devuelve [reply].
class _ChatbotRule {
  const _ChatbotRule({
    required this.keywords,
    required this.reply,
    this.suggestions = const <String>[],
  });

  final List<String> keywords;
  final String reply;
  final List<String> suggestions;
}

/// Asistente estático de LexApp.
///
/// Responde exclusivamente con reglas locales ([_ChatbotRule]): no realiza
/// llamadas de red, por lo que funciona sin conexión y con respuestas
/// predecibles y auditables.
class ChatbotService extends ChangeNotifier {
  ChatbotService() {
    _messages.add(_welcome());
  }

  /// Etiqueta que, al pulsarla, deriva la conversación a un abogado real en
  /// lugar de enviarse como un mensaje normal.
  static const String escalateLabel = 'Hablar con un abogado';

  /// Pausa simulada antes de mostrar la respuesta, para que el flujo se sienta
  /// natural. Es fija (no aleatoria) para que los tests sean deterministas.
  static const Duration replyDelay = Duration(milliseconds: 1100);

  static const _fallback = _ChatbotRule(
    keywords: [],
    reply:
        'No estoy seguro de haber entendido. Puedo orientarte sobre casos, '
        'documentos, pagos, citas o seguridad. Si prefieres, te derivo con un '
        'abogado.',
    suggestions: ['Ver mis casos', 'Consultar pagos', escalateLabel],
  );

  static const List<_ChatbotRule> _rules = [
    _ChatbotRule(
      keywords: [
        'hola',
        'buenos dias',
        'buenas tardes',
        'buenas noches',
        'que tal',
        'hey',
        'saludos',
        'como estas',
      ],
      reply:
          '¡Hola! 👋 Soy el asistente de LexApp. Puedo orientarte sobre tus '
          'casos, documentos, pagos y citas. ¿En qué te ayudo hoy?',
      suggestions: [
        'Ver mis casos',
        'Estado de mis documentos',
        'Consultar pagos',
      ],
    ),
    _ChatbotRule(
      keywords: [
        'ayuda',
        'que puedes hacer',
        'como funciona',
        'opciones',
        'menu',
        'servicios',
        'para que sirves',
      ],
      reply: 'Puedo ayudarte con estas tareas de tu cuenta:',
      suggestions: [
        'Ver mis casos',
        'Consultar pagos',
        'Agendar una cita',
        'Firmar un documento',
      ],
    ),
    _ChatbotRule(
      keywords: [
        'caso',
        'casos',
        'expediente',
        'expedientes',
        'seguimiento',
        'avance',
        'proceso',
        'estatus',
        'tramite',
      ],
      reply:
          'Tienes 2 casos activos: LX-2024-8841 (85% de avance) y Caso #1024 '
          '(40%). El detalle completo está en la sección "Mis casos".',
      suggestions: ['Ver mis casos', escalateLabel],
    ),
    _ChatbotRule(
      keywords: [
        'documento',
        'documentos',
        'contrato',
        'archivo',
        'archivos',
        'pdf',
        'firma',
        'firmar',
        'firmado',
      ],
      reply:
          'Tienes 1 documento pendiente de firma: '
          'adenda_modificacion_clausula_penal.pdf. Puedes revisarlo y firmarlo '
          'desde la sección de Documentos.',
      suggestions: ['Ver documentos', 'Firmar un documento'],
    ),
    _ChatbotRule(
      keywords: [
        'pago',
        'pagos',
        'factura',
        'recibo',
        'tarjeta',
        'cobro',
        'transferencia',
        'deposito',
        'precio',
        'precios',
        'cuesta',
        'costo',
        'costos',
        'honorarios',
        'tarifa',
        'cuanto',
      ],
      reply:
          'Tu último pago de \$75.40 MXN quedó confirmado (folio LX-2024-1182). '
          'En "Pagos" encuentras el historial y los métodos guardados.',
      suggestions: ['Ver métodos de pago', 'Consultar facturas'],
    ),
    _ChatbotRule(
      keywords: [
        'cita',
        'citas',
        'reunion',
        'reuniones',
        'agenda',
        'agendar',
        'horario',
        'calendario',
        'programar',
        'disponible',
      ],
      reply:
          'Tienes una videollamada con la Dra. Elena Ramos hoy a las 16:30. '
          'También puedes agendar una nueva cita desde tu calendario.',
      suggestions: ['Agendar una cita', 'Ver mis citas'],
    ),
    _ChatbotRule(
      keywords: [
        'abogado',
        'abogada',
        'abogados',
        'humano',
        'persona',
        'asesor',
        'licenciado',
        'atender',
      ],
      reply:
          'Con gusto te conecto con un abogado de la plataforma. Puedes iniciar '
          'una conversación o una videollamada desde Mensajes.',
      suggestions: [escalateLabel, 'Agendar videollamada'],
    ),
    _ChatbotRule(
      keywords: [
        'soporte',
        'contactar',
        'reportar',
        'incidente',
        'reclamo',
        'queja',
      ],
      reply:
          'Puedes reportar el incidente desde Seguridad o solicitar soporte de '
          'identidad jurídica. El equipo responde en menos de 24 horas hábiles.',
      suggestions: ['Ir a seguridad', escalateLabel],
    ),
    _ChatbotRule(
      keywords: [
        'privacidad',
        'seguro',
        'seguridad',
        'cifrado',
        'confidencial',
        'proteccion',
        'datos',
        'rgpd',
      ],
      reply:
          'Tus datos van cifrados con estándar judicial de 256 bits y el canal '
          'cumple con RGPD eIDAS. Por seguridad, no compartas correos ni '
          'teléfonos dentro del chat.',
      suggestions: [escalateLabel, 'Ver mis casos'],
    ),
    _ChatbotRule(
      keywords: [
        'problema',
        'error',
        'falla',
        'no funciona',
        'urgente',
        'tardanza',
      ],
      reply:
          'Lamento que tengas ese problema. Puedo escalarlo a soporte o a tu '
          'abogado asignado para revisarlo con detalle. ¿Qué opción prefieres?',
      suggestions: ['Contactar soporte', escalateLabel],
    ),
    _ChatbotRule(
      keywords: [
        'adios',
        'chao',
        'hasta luego',
        'hasta pronto',
        'gracias',
        'bye',
        'nos vemos',
      ],
      reply:
          '¡Con gusto! Aquí estaré cuando me necesites. Tu abogado asignado '
          'también puede atenderte por Mensajes.',
      suggestions: <String>[],
    ),
  ];

  final List<ChatbotMessage> _messages = [];
  Timer? _replyTimer;
  bool _isTyping = false;
  String? _warning;

  List<ChatbotMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  /// Restricción detectada en el último envío; `null` si no hay ninguna.
  String? get warning => _warning;

  /// Agrega el mensaje del usuario y agenda la respuesta del asistente.
  ///
  /// Devuelve `false` cuando el texto está vacío o viola las restricciones de
  /// contacto, caso en el que [warning] explica el motivo.
  bool send(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;

    final warning = ContactValidator.findRestrictedContact(trimmed);
    if (warning != null) {
      _warning = warning;
      notifyListeners();
      return false;
    }
    _warning = null;

    _messages.add(
      ChatbotMessage(
        text: trimmed,
        sender: ChatbotSender.user,
        time: _now(),
      ),
    );
    notifyListeners();

    // Debounce: si el usuario envía varios mensajes seguidos, solo se responde
    // al último para evitar respuestas cruzadas.
    _replyTimer?.cancel();
    _isTyping = true;
    notifyListeners();
    _replyTimer = Timer(replyDelay, _reply);
    return true;
  }

  /// Descarta la conversación actual y vuelve al mensaje de bienvenida.
  void reset() {
    _replyTimer?.cancel();
    _isTyping = false;
    _warning = null;
    _messages
      ..clear()
      ..add(_welcome());
    notifyListeners();
  }

  void clearWarning() {
    if (_warning != null) {
      _warning = null;
      notifyListeners();
    }
  }

  void _reply() {
    final lastUser = _messages.lastWhere(
      (message) => message.sender == ChatbotSender.user,
      orElse: () => _messages.isNotEmpty ? _messages.first : _welcome(),
    );
    final rule = _match(lastUser.text);

    _messages.add(
      ChatbotMessage(
        text: rule.reply,
        sender: ChatbotSender.bot,
        time: _now(),
        suggestions: rule.suggestions,
      ),
    );
    _isTyping = false;
    notifyListeners();
  }

  /// Selecciona la regla con más coincidencias; en empate gana la primera,
  /// por lo que las reglas más específicas se declaran antes que las genéricas.
  _ChatbotRule _match(String raw) {
    final padded = ' ${_normalize(raw)} ';
    var best = _fallback;
    var bestScore = 0;

    for (final rule in _rules) {
      var score = 0;
      for (final keyword in rule.keywords) {
        if (padded.contains(' $keyword ')) score++;
      }
      if (score > bestScore) {
        bestScore = score;
        best = rule;
      }
    }
    return best;
  }

  /// Minúsculas sin acentos y solo `[a-z0-9 ]`, para que las reglas no dependan
  /// de mayúsculas, tildes ni puntuación.
  static String _normalize(String value) {
    const accented = 'áàäâãéèëêíìïîóòöôõúùüûñç';
    const plain = 'aaaaaeeeeiiiiooooouuuunc';

    final buffer = StringBuffer();
    for (final char in value.toLowerCase().split('')) {
      final index = accented.indexOf(char);
      buffer.write(index == -1 ? char : plain[index]);
    }
    return buffer
        .toString()
        .replaceAll(RegExp('[^a-z0-9\\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static ChatbotMessage _welcome() => ChatbotMessage(
    text:
        '¡Hola! Soy el asistente de LexApp. Puedo orientarte sobre tus casos, '
        'documentos, pagos y citas.',
    sender: ChatbotSender.bot,
    time: _now(),
    suggestions: const ['Ver mis casos', 'Consultar pagos', escalateLabel],
  );

  static String _now() {
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    _replyTimer?.cancel();
    super.dispose();
  }
}
