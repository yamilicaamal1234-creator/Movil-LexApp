import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../models/chatbot_message.dart';
import '../services/chatbot_service.dart';

/// Conversación con el asistente estático de LexApp.
///
/// Sigue el mismo lenguaje visual que [ChatScreen] (burbujas, banner de
/// seguridad y barra de entrada) pero con respuestas locales de
/// [ChatbotService].
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  int _lastMessageCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(ChatbotService service, {String? forcedText}) {
    final text = forcedText ?? _controller.text;
    if (!service.send(text)) {
      final warning = service.warning;
      if (warning != null) {
        service.clearWarning();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.navy,
            behavior: SnackBarBehavior.floating,
            content: Text(warning),
          ),
        );
      }
      return;
    }
    if (forcedText == null) _controller.clear();
    _scrollToBottom();
  }

  void _onSuggestion(ChatbotService service, String suggestion) {
    if (suggestion == ChatbotService.escalateLabel) {
      Navigator.pushNamed(context, AppRoutes.chat);
      return;
    }
    _send(service, forcedText: suggestion);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatbotService>(
      builder: (context, service, _) {
        // La lista creció (respuesta o reinicio): llevar el hilo al final.
        if (service.messages.length != _lastMessageCount) {
          _lastMessageCount = service.messages.length;
          _scrollToBottom();
        }

        final last = service.messages.isEmpty ? null : service.messages.last;
        final suggestions = last != null &&
                last.sender == ChatbotSender.bot &&
                !service.isTyping
            ? last.suggestions
            : const <String>[];

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            toolbarHeight: 76,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            titleSpacing: 0,
            title: const Row(
              children: [
                _BotAvatar(radius: 23),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asistente LexApp',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Respuesta inmediata',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.emerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Reiniciar conversación',
                onPressed: service.reset,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.smart_toy_outlined,
                      size: 15,
                      color: AppColors.slate,
                    ),
                    SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        'Asistente automatizado • Información general',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: AppColors.slate),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  itemCount:
                      service.messages.length + (service.isTyping ? 1 : 0),
                  itemBuilder: (_, index) {
                    if (index >= service.messages.length) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: _TypingIndicator(),
                      );
                    }
                    return _Bubble(message: service.messages[index]);
                  },
                ),
              ),
              if (suggestions.isNotEmpty)
                _SuggestionRow(
                  suggestions: suggestions,
                  onSelected: (value) => _onSuggestion(service, value),
                ),
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          maxLines: 4,
                          minLines: 1,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Escribe tu pregunta...',
                            filled: true,
                            fillColor: AppColors.bg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _controller.text.trim().isEmpty
                            ? null
                            : () => _send(service),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _controller.text.trim().isEmpty
                                ? AppColors.slate
                                : AppColors.emerald,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BotAvatar extends StatelessWidget {
  const _BotAvatar({this.radius = 23});
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.emerald.withValues(alpha: 0.15),
      child: const Icon(
        Icons.smart_toy_rounded,
        color: AppColors.emerald,
        size: 24,
      ),
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.suggestions, required this.onSelected});

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final label = suggestions[index];
          return ActionChip(
            onPressed: () => onSelected(label),
            avatar: const Icon(
              Icons.bolt_rounded,
              size: 16,
              color: AppColors.emerald,
            ),
            label: Text(label),
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.emerald,
            ),
            backgroundColor: AppColors.tint,
            side: BorderSide(
              color: AppColors.emerald.withValues(alpha: 0.4),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}

/// Indicador animado de "escribiendo..." con tres puntos.
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) => _Dot(_controller, index)),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot(this.animation, this.index);
  final Animation<double> animation;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(
            index * 0.2,
            index * 0.2 + 0.4,
            curve: Curves.easeInOut,
          ),
        ),
      ),
      child: Container(
        width: 7,
        height: 7,
        margin: EdgeInsets.only(right: index == 2 ? 0 : 5),
        decoration: const BoxDecoration(
          color: AppColors.emerald,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});
  final ChatbotMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatbotSender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .78,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.emerald : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: isUser ? null : Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                height: 1.45,
                color: isUser ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                message.time,
                style: TextStyle(
                  fontSize: 10,
                  color: isUser ? Colors.white70 : AppColors.slate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
