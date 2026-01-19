import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practicas/features/chutes_chat/controllers/chat_controller.dart';
import 'package:practicas/features/chutes_chat/widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatController ctrl;
  late final TextEditingController inputCtrl;
  late final ScrollController scrollCtrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.find<ChatController>();
    inputCtrl = TextEditingController();
    scrollCtrl = ScrollController();

    // Si se recibió un mensaje inicial por argumentos, enviarlo tras el primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      if (args is Map && args.containsKey('initialMessage')) {
        final initial = args['initialMessage'];
        if (initial is String && initial.trim().isNotEmpty) {
          // enviar pero no bloquear el initState
          ctrl.sendUserMessage(initial);
        }
      }
    });
  }

  @override
  void dispose() {
    inputCtrl.dispose();
    scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    if (!scrollCtrl.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        scrollCtrl.animateTo(
          scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chutes Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final msgs = ctrl.messages;
              // Después de cada cambio en mensajes, desplazar al final
              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
              return ListView.builder(
                controller: scrollCtrl,
                reverse: false,
                itemCount: msgs.length,
                itemBuilder: (context, index) {
                  final m = msgs[index];
                  return MessageBubble(message: m);
                },
              );
            }),
          ),
          Obx(() => ctrl.errorMessage.value != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(ctrl.errorMessage.value ?? '', style: const TextStyle(color: Colors.red)),
                )
              : const SizedBox.shrink()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inputCtrl,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(hintText: 'Escribe tu pregunta...'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => IconButton(
                        onPressed: ctrl.isLoading.value
                            ? null
                            : () async {
                                final text = inputCtrl.text;
                                inputCtrl.clear();
                                await ctrl.sendUserMessage(text);
                              },
                        icon: const Icon(Icons.send),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
