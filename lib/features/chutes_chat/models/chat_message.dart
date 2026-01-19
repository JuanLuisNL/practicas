// Modelo de un mensaje de chat
class ChatMessage {
  final String id;
  final String role; // 'system' | 'user' | 'assistant'
  final String content;
  final DateTime createdAt;
  MessageStatus status;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    DateTime? createdAt,
    this.status = MessageStatus.sent,
  }) : createdAt = createdAt ?? DateTime.now();
}

enum MessageStatus { sending, sent, failed }
