import 'package:get/get.dart';
import 'package:practicas/features/chutes_chat/controllers/chat_controller.dart';
import 'package:practicas/features/chutes_chat/services/chutes_api_service.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    // Inyectar la apiKey aquí. Para seguridad, no embebas la clave en código.
    const apiKey = 'cpk_4225ff4eb54841eaa120ccc0d386c542.92cbab03130f5134b8053687e8f28f78.ibGP3wwyQ7O4bGqcY5vqkvEGy2x5EEMb';
    final url = Uri.parse('https://llm.chutes.ai/v1/chat/completions');

    // Activar debug=true temporalmente para ver respuestas en consola
    Get.put(ChutesApiService(apiKey: apiKey, url: url, debug: true));
    Get.put(ChatController(apiService: Get.find<ChutesApiService>(), model: 'Qwen/Qwen3-Next-80B-A3B-Instruct'));
  }
}
