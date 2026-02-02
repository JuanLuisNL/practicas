import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practicas/screens/widgets/boton_verial.dart';
import '../../widgets/card_moderno.dart';
import 'columnas_controller.dart';

class ColumnasFilasPage extends StatelessWidget {
  const ColumnasFilasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inyectar controlador si no existe
    final ctr = Get.put(ColumnasController());

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
            child: Obx(() => Column(
                children: [
                  const SizedBox(height: 8),
                  Text('Demostración: ${ctr.oColsGrid.value} columnas', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 8),
                  // 3 botones para cambiar el número de columnas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BotonVerialWidget(
                        onPressed: () => ctr.setNCols(2),
                        label: '2 Columnas',
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => ctr.setNCols(3),
                        child: const Text('3 Columnas'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => ctr.setNCols(4),
                        child: const Text('4 Columnas'),
                      ),
                    ],                  ),

                  const SizedBox(height: 12),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Grid que mantiene celdas cuadradas con childAspectRatio = 1
                        return Obx(() {
                          // Capturamos el valor observable aquí, dentro del scope del Obx,
                          // para que GetX detecte la dependencia correctamente.
                          final currentSelected = ctr.selected.value;
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: ctr.oColsGrid.value,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1, // cuadrado
                            ),
                            itemCount: ctr.items.length,
                            itemBuilder: (context, index) {
                              final item = ctr.items[index];
                              final row = index ~/ 3;
                              final bg = ctr.colorForRow(row);
                              final isSelected = currentSelected == index;

                              return ModernCardWidget(
                                label: item.label,
                                iconData: item.icon,
                                backgroundColor: bg,
                                minSize: 90,
                                borderRadius: 10,
                                elevation: isSelected ? 12 : 6,
                                selected: isSelected,
                                onTap: () => ctr.select(index),
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
      ),
    );
  }
}
