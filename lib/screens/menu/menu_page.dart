import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import '../../global/dialogos.dart';
import '../../global/widgets/boton_verial.dart';
import '../basic/menu/menu_basic_page.dart';
import 'menu_controller.dart';
import '../json_view/json_view_page.dart';
import '../camera/camera_page.dart';


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
                // Usamos ListView.builder en lugar de map() para crear los hijos
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final it = controller.items[index];
                    return _menuButton(it, controller);
                  },
                ),
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
      child: BotonVerialWidget(
        label: item.label,
        icon: Icon(item.icon, size: 18),
        backColor: selected ? Colors.blue.shade200 : Colors.white,
        ancho: 250,
        onPressed: () async {
          controller.select(item.option);
          switch (item.option) {
            case EnumMenuOption.json:
              Get.to(() => const JsonViewPage());
              break;
            case EnumMenuOption.api:
              // Navegar a la página de chat (ruta registrada en main.dart)
              Get.toNamed('/chat');
              break;
            case EnumMenuOption.camara:
              Get.to(() => const CameraPage());
              break;
            case EnumMenuOption.course:
              Get.toNamed('/course');
              break;
            case EnumMenuOption.imagenes:
              Get.toNamed('/images');
              break;
            case EnumMenuOption.checkbox:
              Get.toNamed('/checkbox');
              break;
            case EnumMenuOption.basic:
              Get.to(() => const MenuBasicPage());
            case EnumMenuOption.salir:
              // cerrar una aplicacion windows
          if (await Dialogos.ynMessage("", "¿Está seguro de que desea salir de la aplicación?")) {
          await windowManager.destroy(); // Permitir cierre si estamos en el menú
          }

            default:
              break;
          }
        },
      ),
    );
  }
}
