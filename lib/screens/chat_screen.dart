import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();

  Future<void> attachFile(ChatService service) async {
    final result = await FilePicker.pickFiles(
      allowMultiple: false,
      withData: false,
      withReadStream: false,
    );
    if (!mounted || result == null || result.files.isEmpty) return;

    final file = result.files.single;
    final size = _formatFileSize(file.size);
    final name = file.name;
    final extension = name.contains('.')
        ? name.split('.').last.toUpperCase()
        : 'ARCHIVO';
    final sent = service.sendMessage(
      '',
      attachment: ChatAttachment(
        name: name,
        size: size,
        extension: extension,
        path: file.path,
      ),
    );
    if (!sent) return;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void send(ChatService service) {
    final text = controller.text.trim();
    final email = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final phone = RegExp(
      r'\b(?:\+?52)?\s*\(?\d{2,3}\)?[-\s]?\d{3,4}[-\s]?\d{4}\b',
    );
    final tenDigits = RegExp(r'\b\d{10}\b');
    if (email.hasMatch(text) ||
        phone.hasMatch(text) ||
        tenDigits.hasMatch(text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por seguridad de tu caso, no está permitido compartir datos personales o de contacto externos dentro de la plataforma',
          ),
        ),
      );
      return;
    }
    if (text.isEmpty) return;
    service.sendMessage(text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatService>(
      builder: (context, service, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF3F6F8),
          appBar: AppBar(
            toolbarHeight: 76,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            titleSpacing: 0,
            title: const Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: AppColors.border,
                  child: Text(
                    'AG',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lic. Alejandro Garcia',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'En línea',
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
                tooltip: 'Llamada de audio',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.waitingRoom,
                  arguments: false,
                ),
                icon: const Icon(Icons.call_outlined),
              ),
              IconButton(
                tooltip: 'Videollamada',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.waitingRoom,
                  arguments: true,
                ),
                icon: const Icon(Icons.videocam_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.info_outline_rounded),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 15,
                      color: AppColors.slate,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Chat cifrado de extremo a extremo',
                      style: TextStyle(fontSize: 12, color: AppColors.slate),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  itemCount:
                      service.messages.length + (service.isTyping ? 1 : 0),
                  itemBuilder: (_, index) {
                    if (service.isTyping && index == service.messages.length) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'El abogado está escribiendo...',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.slate,
                          ),
                        ),
                      );
                    }
                    return ChatBubble(message: service.messages[index]);
                  },
                ),
              ),
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Adjuntar archivo',
                        onPressed: () => attachFile(service),
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Escribe un mensaje...',
                            filled: true,
                            fillColor: AppColors.background,
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
                        onTap: () => send(service),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.emerald,
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

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final client = message.sender == MessageSender.client;
    return Align(
      alignment: client ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .78,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: client ? AppColors.emerald : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(client ? 16 : 4),
            bottomRight: Radius.circular(client ? 4 : 16),
          ),
          border: client ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.text.isNotEmpty)
              Text(
                message.text,
                style: TextStyle(
                  height: 1.45,
                  color: client ? AppColors.white : AppColors.navy,
                ),
              ),
            if (message.attachment != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.attachment!.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          Text(
                            message.attachment!.size,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.slate,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.download_rounded,
                        color: AppColors.emerald,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                message.time,
                style: TextStyle(
                  fontSize: 10,
                  color: client ? Colors.white70 : AppColors.slate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
