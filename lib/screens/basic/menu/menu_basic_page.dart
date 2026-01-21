import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global/widgets/boton_verial.dart';
import '../../menu/menu_controller.dart';
import 'menu_basic_controller.dart';


class MenuBasicPage extends StatelessWidget {
  const MenuBasicPage({super.key});

  @override
  Widget build(BuildContext context) {
    // La lista de elementos ahora viene del controller: controller.items

    return Scaffold(
      body: Center(
        child: GetBuilder<MenuBasicController>(
          init: MenuBasicController(),
          builder: (controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Usamos ListView.builder en lugar de map() para crear los hijos
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.lstItems.length,
                  itemBuilder: (context, index) {
                    final it = controller.lstItems[index];
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
  Widget _menuButton(MenuItem item, MenuBasicController controller) {
    final selected = controller.selected == item.option;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BotonVerialWidget(
        label: item.label,
        icon: Icon(item.icon, size: 18),
        backColor: selected ? Colors.blue.shade200 : Colors.white,
        ancho: 250,
        onPressed: () {
          controller.select(item.option);
          switch (item.option) {
            case EnumMenuOption.columnasRows:
              Get.toNamed('/columnas');
              break;
            case EnumMenuOption.sqlite:
              Get.toNamed('/sqlite');
              break;
            case EnumMenuOption.salir:
              Get.back();
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
