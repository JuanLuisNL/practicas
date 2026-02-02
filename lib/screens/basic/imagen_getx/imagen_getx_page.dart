import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'imagen_getx_controller.dart';

class ImagenGetxPage extends StatelessWidget {
  ImagenGetxPage({Key? key}) : super(key: key);

  final ImagenGetxController controller =
      Get.put(ImagenGetxController(), tag: 'imagen_ctrl');

  final TextEditingController _textCtrl = TextEditingController(
    text:
        'https://picsum.photos/600/400', // valor por defecto para demostrar
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagen con GetX'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Introduce una URL de imagen o usa los botones de ejemplo',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'URL de la imagen',
                    ),
                    keyboardType: TextInputType.url,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    controller.setUrl(_textCtrl.text);
                  },
                  child: const Text('Cargar'),
                )
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => controller.setUrl('https://picsum.photos/600/400'),
                  child: const Text('Ejemplo 1'),
                ),
                ElevatedButton(
                  onPressed: () => controller.setUrl('https://picsum.photos/seed/picsum/800/600'),
                  child: const Text('Ejemplo 2'),
                ),
                ElevatedButton(
                  onPressed: () => controller.setUrl('https://invalid.url/404.png'),
                  child: const Text('URL inválida'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _textCtrl.text = 'https://picsum.photos/600/400';
                    controller.setUrl(_textCtrl.text);
                  },
                  child: const Text('Auto-cargar'),
                ),
                OutlinedButton(
                  onPressed: controller.clear,
                  child: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final url = controller.imageUrl.value;
                if (url.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay imagen cargada',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }

                return Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.broken_image, size: 56, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Error al cargar la imagen', style: TextStyle(color: Colors.grey)),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
