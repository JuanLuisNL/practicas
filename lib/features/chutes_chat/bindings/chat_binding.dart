import 'package:get/get.dart';
import 'package:practicas/features/chutes_chat/controllers/chat_controller.dart';
import 'package:practicas/features/chutes_chat/services/chutes_api_service.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    // Inyectar la apiKey aquí. Para seguridad, no embebas la clave en código.
    const apiKey = '';
    final url = Uri.parse('https://llm.chutes.ai/v1/chat/completions');

    // Activar debug=true temporalmente para ver respuestas en consola
    Get.put(ChutesApiService(apiKey: apiKey, url: url, debug: true));
    Get.put(ChatController(apiService: Get.find<ChutesApiService>(), model: 'openai/gpt-oss-120b'));
  }
}
