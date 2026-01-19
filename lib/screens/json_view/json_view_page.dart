import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:json_view/json_view.dart';

import 'json_view_controller.dart';

class JsonViewPage extends StatelessWidget {
  const JsonViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Put controller if not already
    final controller = Get.put(JsonViewController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON desde Assets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copiar JSON',
            onPressed: () {
              final d = controller.data.value;
              if (d != null) {
                final text = const JsonEncoder.withIndent('  ').convert(d);
                Clipboard.setData(ClipboardData(text: text));
                Get.snackbar('Copiado', 'JSON copiado al portapapeles', snackPosition: SnackPosition.BOTTOM);
              } else {
                Get.snackbar('Nada', 'No hay JSON para copiar', snackPosition: SnackPosition.BOTTOM);
              }
            },
          )
        ],
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }

          if (controller.error.value != null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(controller.error.value ?? 'Error'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.load,
                  child: const Text('Reintentar'),
                )
              ],
            );
          }

          final d = controller.data.value;
          if (d == null) {
            return const Text('Sin datos');
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // título pequeño con info
                Text('Visualización de JSON', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: JsonView(
                      json: d is Map ? d : {'root': d},
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
