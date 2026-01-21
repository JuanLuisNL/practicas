import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trina_grid/trina_grid.dart';
import 'sqlite_controller.dart';

class SqlitePage extends StatelessWidget {
  const SqlitePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SqliteController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visor de Base de Datos SQLite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refresh(),
            tooltip: 'Recargar',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando base de datos...'),
              ],
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => controller.refresh(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.columns.isEmpty || controller.rows.isEmpty) {
          return const Center(
            child: Text('No hay datos para mostrar'),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.storage, color: Colors.blue),
                      const SizedBox(width: 12),
                      Text(
                        'Registros encontrados: ${controller.rows.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TrinaGrid(
                  columns: controller.columns,
                  rows: controller.rows,
                  onLoaded: (TrinaGridOnLoadedEvent event) {
                    event.stateManager.setShowColumnFilter(true);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
