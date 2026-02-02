import 'package:get/get.dart';

/// Controller simple para manejar la URL de la imagen con GetX.
class ImagenGetxController extends GetxController {
  // URL de la imagen (vacía == sin imagen)
  final imageUrl = ''.obs;

  /// Establece la URL (se recorta)
  void setUrl(String url) => imageUrl.value = url.trim();

  /// Limpia la URL
  void clear() => imageUrl.value = '';
}
