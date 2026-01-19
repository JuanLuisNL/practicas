import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'camera_controller.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CamaraController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara'),
      ),
      body: Center(
        child: GetBuilder<CamaraController>(
          builder: (c) {
            if (c.isLoading.value) return const CircularProgressIndicator();
            if (c.error.value != null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(c.error.value ?? 'Error'),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: () => c.init(), child: const Text('Reintentar')),
                ],
              );
            }

            if (c.cameraController == null || !c.cameraController!.value.isInitialized) {
              return const Text('Cámara no disponible');
            }

            final preview = CameraPreview(c.cameraController!);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Camara: ${camerasLabel(c)}'),
                      Row(
                        children: [
                          if (c.cameras.length > 1)
                            IconButton(
                              icon: const Icon(Icons.switch_camera),
                              onPressed: c.switchCamera,
                              tooltip: 'Cambiar cámara',
                            ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(child: preview),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: c.takePicture,
                      child: const Text('Tomar foto'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        final photo = c.lastPhoto.value;
                        if (photo == null) {
                          Get.snackbar('No hay foto', 'Aún no has tomado una foto', snackPosition: SnackPosition.BOTTOM);
                          return;
                        }
                        Get.to(() => PreviewPage(photo.path));
                      },
                      child: const Text('Ver última'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (c.lastSavedPath.value != null) Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Última guardada: ${c.lastSavedPath.value}'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// helper para etiqueta de la camara
String camerasLabel(CamaraController c) {
  try {
    if (c.cameras.isEmpty) return 'ninguna';
    final desc = c.cameras[c.selectedIndex];
    return describeCamera(desc);
  } catch (_) { return '';}
}

String describeCamera(CameraDescription d) => d.lensDirection.name;

class PreviewPage extends StatelessWidget {
  final String path;
  const PreviewPage(this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: Center(
        child: Image.file(File(path)),
      ),
    );
  }
}
