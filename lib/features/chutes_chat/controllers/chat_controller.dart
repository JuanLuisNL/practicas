import 'dart:math';

import 'package:get/get.dart';
import 'package:practicas/features/chutes_chat/models/chat_message.dart';
import 'package:practicas/features/chutes_chat/services/chutes_api_service.dart';

class ChatController extends GetxController {
  final ChutesApiService apiService;
  final String model;

  ChatController({required this.apiService, required this.model});

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  final _rand = Random();

  String _generateId() => '${DateTime.now().microsecondsSinceEpoch}-${_rand.nextInt(100000)}';

  Future<void> sendUserMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final msg = ChatMessage(
      id: _generateId(),
      role: 'user',
      content: trimmed,
      status: MessageStatus.sending,
    );

    messages.add(msg);
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await apiService.createChatCompletion(
        messages: messages,
        model: model,
        temperature: 0.0,
        maxTokens: 1024,
        stream: false,
      );

      // Append assistant reply(s). Si no hay choices o el contenido está vacío,
      // añadimos un mensaje asistente por defecto para que el chat muestre algo.
      if (response.choices.isEmpty) {
        messages.add(ChatMessage(
          id: _generateId(),
          role: 'assistant',
          content: 'No se recibió respuesta del modelo.',
          status: MessageStatus.sent,
        ));
      } else {
        for (var choice in response.choices) {
          final content = choice.content.trim();
          final display = content.isEmpty ? '[Respuesta vacía]' : content;
          final assistantMsg = ChatMessage(
            id: _generateId(),
            role: choice.role.isNotEmpty ? choice.role : 'assistant',
            content: display,
            status: MessageStatus.sent,
          );
          messages.add(assistantMsg);
        }
      }

      // Mark last user message as sent
      final idx = messages.indexWhere((m) => m.id == msg.id);
      if (idx != -1) messages[idx].status = MessageStatus.sent;
    } catch (e) {
      // Mark message failed
      final idx = messages.indexWhere((m) => m.id == msg.id);
      if (idx != -1) messages[idx].status = MessageStatus.failed;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retryMessage(String messageId) async {
    final idx = messages.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;
    final message = messages[idx];
    message.status = MessageStatus.sending;
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await apiService.createChatCompletion(
        messages: messages,
        model: model,
      );

      for (var choice in response.choices) {
        final assistantMsg = ChatMessage(
          id: _generateId(),
          role: choice.role,
          content: choice.content,
          status: MessageStatus.sent,
        );
        messages.add(assistantMsg);
      }

      messages[idx].status = MessageStatus.sent;
    } catch (e) {
      messages[idx].status = MessageStatus.failed;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clearChat() {
    messages.clear();
    errorMessage.value = null;
  }
}
