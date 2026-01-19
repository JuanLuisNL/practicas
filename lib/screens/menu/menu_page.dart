import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'menu_controller.dart';
import 'menu_option.dart';
import '../json_view/json_view_page.dart';
import '../camera/camera_page.dart';
import 'menu_item.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // La lista de elementos ahora viene del controller: controller.items

    return Scaffold(
      body: Center(
        child: GetBuilder<MenuPracticasController>(
          init: MenuPracticasController(),
          builder: (controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...controller.items.map((it) => _menuButton(it, controller)),
                const SizedBox(height: 24),
                Text('Seleccionado: ${controller.selected.name}'),
              ],
            );
          },
        ),
      ),
    );
  }

  // Método privado que crea el botón de menú. Recibe el texto y el índice (tipo).
  Widget _menuButton(MenuItem item, MenuPracticasController controller) {
    final selected = controller.selected == item.option;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          backgroundColor: selected ? Colors.blue : null,
        ),
        onPressed: () {
          controller.select(item.option);
          switch (item.option) {
            case MenuOption.json:
              Get.to(() => const JsonViewPage());
              break;
            case MenuOption.api:
              // Navegar a la página de chat (ruta registrada en main.dart)
              Get.toNamed('/chat');
              break;
            case MenuOption.camara:
              Get.to(() => const CameraPage());
              break;
            case MenuOption.course:
              Get.toNamed('/course');
              break;
            case MenuOption.imagenes:
              Get.toNamed('/images');
              break;
            case MenuOption.checkbox:
              Get.toNamed('/checkbox');
              break;
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[Icon(item.icon, size: 18), const SizedBox(width: 8)],
            Text(item.label),
          ],
        ),
      ),
    );
  }
}
