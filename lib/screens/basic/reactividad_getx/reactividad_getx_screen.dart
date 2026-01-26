import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'reactividad_getx_controller.dart';

/// Ejercicio de reactividad con GetX
/// Demuestra el uso de Obx(), GetBuilder y variables reactivas (.obs)
class ReactividadGetxScreen extends StatelessWidget {
  ReactividadGetxScreen({Key? key}) : super(key: key);

  // Instanciar el controller (GetX lo maneja automáticamente)
  final ctr = Get.put(ReactividadGetxController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reactividad - GetX'), backgroundColor: ctr.colorTitulo.value, elevation: 4),
      // Obx para el background reactivo
      body: GetBuilder(
        init: ctr,
        builder: (controller) {
          return Container(
            color: ctr.colorFondo.value,
            child: Column(
              children: [
                // PARTE SUPERIOR: Título y Contador
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Título reactivo con Obx
                      Obx(
                        () => Text(
                          'Mi Contador GetX',
                          style: TextStyle(
                            fontSize: ctr.tamanoTitulo.value,
                            fontWeight: FontWeight.bold,
                            color: ctr.colorTitulo.value,
                            shadows: [Shadow(color: Colors.black.withAlpha((0.3 * 255).round()), blurRadius: 4, offset: const Offset(2, 2))],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // CONTADOR CON BOTONES - Y +
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.1 * 255).round()),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withAlpha((0.2 * 255).round()), width: 2),
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.2 * 255).round()), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botón MENOS
                            ElevatedButton.icon(
                              onPressed: ctr.decrementar,
                              icon: const Icon(Icons.remove, size: 24),
                              label: const Text('Menos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), elevation: 6),
                            ),
                            const SizedBox(width: 30),
                            // LABEL DEL CONTADOR - Reactivo con Obx
                            Obx(
                              () => Text(
                                '${ctr.contador.value}',
                                style: TextStyle(
                                  fontSize: ctr.tamanoLabel.value,
                                  fontWeight: FontWeight.w900,
                                  color: ctr.colorLabel.value,
                                  shadows: [Shadow(color: Colors.black.withAlpha((0.4 * 255).round()), blurRadius: 6, offset: const Offset(2, 2))],
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            // Botón MÁS
                            ElevatedButton.icon(
                              onPressed: ctr.incrementar,
                              icon: const Icon(Icons.add, size: 24),
                              label: const Text('Más', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), elevation: 6),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // PARTE INFERIOR: Botones para cambiar estilos
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Personaliza los estilos:',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
                          ),
                          const SizedBox(height: 12),
                          // Fila 1: Colores del título
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildColorButton(Colors.indigo, 'Título Indigo', () => ctr.setColorTitulo(Colors.indigo)),
                              _buildColorButton(Colors.purple, 'Título Purple', () => ctr.setColorTitulo(Colors.purple)),
                              _buildColorButton(Colors.cyan, 'Título Cyan', () => ctr.setColorTitulo(Colors.cyan)),
                              _buildColorButton(Colors.orange, 'Título Orange', () => ctr.setColorTitulo(Colors.orange)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Fila 2: Colores del label
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildColorButton(Colors.white, 'Label Blanco', () => ctr.setColorLabel(Colors.white)),
                              _buildColorButton(Colors.yellow, 'Label Amarillo', () => ctr.setColorLabel(Colors.yellow)),
                              _buildColorButton(Colors.lime, 'Label Lima', () => ctr.setColorLabel(Colors.lime)),
                              _buildColorButton(Colors.pink, 'Label Rosa', () => ctr.setColorLabel(Colors.pink)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Fila 3: Colores del fondo
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildColorButton(Colors.indigo.shade900, 'Fondo Indigo', () => ctr.setColorFondo(Colors.indigo.shade900)),
                              _buildColorButton(Colors.grey.shade900, 'Fondo Gris', () => ctr.setColorFondo(Colors.grey.shade900)),
                              _buildColorButton(Colors.deepPurple.shade900, 'Fondo Purple', () => ctr.setColorFondo(Colors.deepPurple.shade900)),
                              _buildColorButton(Colors.blue.shade900, 'Fondo Azul', () => ctr.setColorFondo(Colors.blue.shade900)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Fila 4: Tamaños
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildStyleButton('Label -', ctr.disminuirTamanoLabel),
                              _buildStyleButton('Label +', ctr.aumentarTamanoLabel),
                              _buildStyleButton('Título -', ctr.disminuirTamanoTitulo),
                              _buildStyleButton('Título +', ctr.aumentarTamanoTitulo),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Botón de reinicio
                          ElevatedButton.icon(
                            onPressed: ctr.reiniciar,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reiniciar Todo'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), elevation: 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Método auxiliar para botones de color
  Widget _buildColorButton(Color color, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
      ),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withAlpha((0.15 * 255).round()), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), elevation: 2),
    );
  }

  // Método auxiliar para botones de estilo
  Widget _buildStyleButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade600, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), elevation: 2),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
