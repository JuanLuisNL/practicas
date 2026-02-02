import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'images_controller.dart';

class ImagesPage extends StatelessWidget {
  const ImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagesController ctrl = Get.put(ImagesController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería de imágenes'),
        actions: [IconButton(onPressed: () => ctrl.clearAll(), icon: const Icon(Icons.delete_forever))],
      ),
      body: Obx(() {
        final lstImgs = ctrl.lstImages;
        if (lstImgs.isEmpty) return const Center(child: Text('No hay imágenes'));
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
          itemCount: lstImgs.length,
          itemBuilder: (context, i) {
            final url = lstImgs[i];
            return GestureDetector(
              onTap: () => Get.to(() => ImageDetailPage(url: url)),
              child: Hero(
                tag: url,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Obx(() {
                        final isFav = ctrl.setFavorites.contains(url);
                        return GestureDetector(
                          onTap: () => ctrl.toggleFavorite(url),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.white,
                            size: 24,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ejemplo: agregar una nueva imagen aleatoria
          final idx = DateTime.now().millisecondsSinceEpoch % 1000;
          final url = 'https://picsum.photos/seed/$idx/800/600';
          ctrl.addImage(url);
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  final String url;

  const ImageDetailPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final ImagesController ctrl = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de imagen'),
        actions: [
          Obx(() => IconButton(icon: Icon(ctrl.setFavorites.contains(url) ? Icons.favorite : Icons.favorite_border, color: Colors.red), onPressed: () => ctrl.toggleFavorite(url))),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ctrl.removeImage(url);
              Get.back();
            },
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: url,
          child: Image.network(url, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
