import 'package:flutter/material.dart';
import 'package:practicas/features/chutes_chat/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isUser ? Colors.blueAccent : Colors.grey.shade200;
    final textColor = isUser ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.content,
            style: TextStyle(color: textColor),
          ),
        ),
        if (message.status == MessageStatus.sending)
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Text('Enviando...', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        if (message.status == MessageStatus.failed)
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Text('Falló. Reintentar', style: TextStyle(fontSize: 12, color: Colors.red)),
          ),
      ],
    );
  }
}
