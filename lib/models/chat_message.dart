enum MessageSender { lawyer, client }

class ChatAttachment {
  const ChatAttachment({
    required this.name,
    required this.size,
    required this.extension,
    this.path,
  });
  final String name;
  final String size;
  final String extension;
  final String? path;
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.sender,
    required this.time,
    this.attachment,
  });
  final String text;
  final MessageSender sender;
  final String time;
  final ChatAttachment? attachment;
}
