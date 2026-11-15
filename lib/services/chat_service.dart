import 'dart:async';
import 'package:flutter/material.dart';
import '../core/validators/contact_validator.dart';
import '../models/chat_message.dart';

class ChatService extends ChangeNotifier {
  ChatService() {
    _messages.addAll([
      const ChatMessage(
        text: 'Buenos días, Ricardo. ¿Cómo va el proceso?',
        sender: MessageSender.lawyer,
        time: '9:30 AM',
      ),
      const ChatMessage(
        text: 'Buenos días. Ya revisé los documentos que compartimos.',
        sender: MessageSender.client,
        time: '9:32 AM',
      ),

      const ChatMessage(
        text: 'Muchas gracias, la reviso hoy mismo.',
        sender: MessageSender.client,
        time: '9:38 AM',
      ),
    ]);
  }

  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String? _sendWarning;
  Timer? _replyTimer;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  String? get sendWarning => _sendWarning;

  bool sendMessage(String text, {ChatAttachment? attachment}) {
    final trimmed = text.trim();
    final warning = ContactValidator.findRestrictedContact(trimmed);
    _sendWarning = warning;
    if (warning != null) {
      notifyListeners();
      return false;
    }

    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    _messages.add(
      ChatMessage(
        text: trimmed.isEmpty && attachment != null
            ? 'Archivo adjunto'
            : trimmed,
        sender: MessageSender.client,
        time: '$hour:$minute $period',
        attachment: attachment,
      ),
    );
    _sendWarning = null;
    notifyListeners();

    _isTyping = true;
    notifyListeners();
    _replyTimer?.cancel();
    _replyTimer = Timer(const Duration(milliseconds: 1400), () {
      _messages.add(
        ChatMessage(
          text:
              'Mensaje recibido. Revisaré la información y te responderé en breve.',
          sender: MessageSender.lawyer,
          time: '$hour:$minute $period',
        ),
      );
      _isTyping = false;
      notifyListeners();
    });
    return true;
  }

  void clearWarning() {
    if (_sendWarning != null) {
      _sendWarning = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _replyTimer?.cancel();
    super.dispose();
  }
}
