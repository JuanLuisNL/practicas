import 'package:get/get.dart';

class ImagesController extends GetxController {
  // Lista de URLs de ejemplo (pueden reemplazarse por rutas locales)
  final images = <String>[
    'https://picsum.photos/seed/1/800/600',
    'https://picsum.photos/seed/2/800/600',
    'https://picsum.photos/seed/3/800/600',
    'https://picsum.photos/seed/4/800/600',
    'https://picsum.photos/seed/5/800/600',
    'https://picsum.photos/seed/6/800/600',
  ].obs;

  final favorites = <String>{}.obs;

  void addImage(String url) {
    images.add(url);
  }

  void removeImage(String url) {
    images.remove(url);
    favorites.remove(url);
  }

  void toggleFavorite(String url) {
    if (favorites.contains(url)) {
      favorites.remove(url);
    } else {
      favorites.add(url);
    }
  }

  void clearAll() {
    images.clear();
    favorites.clear();
  }
}
