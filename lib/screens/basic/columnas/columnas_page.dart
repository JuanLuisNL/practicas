import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'card_moderno.dart';
import 'columnas_controller.dart';

class ColumnasPage extends StatelessWidget {
  const ColumnasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inyectar controlador si no existe
    final controller = Get.put(ColumnasController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Columnas - Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          // fondo azul translúcido para toda la pantalla
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade700, Colors.blue.shade400],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text('Demostración: 4 filas x 3 columnas', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Grid que mantiene celdas cuadradas con childAspectRatio = 1
                      return Obx(() {
                        // Capturamos el valor observable aquí, dentro del scope del Obx,
                        // para que GetX detecte la dependencia correctamente.
                        final currentSelected = controller.selected.value;
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1, // cuadrado
                          ),
                          itemCount: controller.items.length,
                          itemBuilder: (context, index) {
                            final item = controller.items[index];
                            final row = index ~/ 3;
                            final bg = controller.colorForRow(row);
                            final isSelected = currentSelected == index;

                            return ModernCardWidget(
                              label: item.label,
                              iconData: item.icon,
                              backgroundColor: bg,
                              minSize: 90,
                              borderRadius: 10,
                              elevation: isSelected ? 12 : 6,
                              selected: isSelected,
                              onTap: () => controller.select(index),
                            );
                          },
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
