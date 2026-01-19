import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonPage extends StatelessWidget {
  final String title;
  final String content;

  const LessonPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(content),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Volver'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Preguntar al asistente'),
                  onPressed: () {
                    // Navegar al chat y pasar el contenido de la lección como mensaje inicial
                    Get.toNamed('/chat', arguments: {'initialMessage': content});
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
