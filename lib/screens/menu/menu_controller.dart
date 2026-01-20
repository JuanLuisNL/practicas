import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/material.dart';

class MenuPracticasController extends GetxController {
  EnumMenuOption selected = EnumMenuOption.json;

  final items = <MenuItem>[
    const MenuItem(label: 'Leer Json de Assets', option: EnumMenuOption.json, icon: Icons.file_present),
    const MenuItem(label: 'Llamar a un API', option: EnumMenuOption.api, icon: Icons.api),
    const MenuItem(label: 'Cámara', option: EnumMenuOption.camara, icon: Icons.camera_alt),
    const MenuItem(label: 'Imágenes', option: EnumMenuOption.imagenes, icon: Icons.image),
    const MenuItem(label: 'Curso (estructura)', option: EnumMenuOption.course, icon: Icons.school),
    const MenuItem(label: 'Checkbox (ejemplo)', option: EnumMenuOption.checkbox, icon: Icons.check_box),
    const MenuItem(label: 'Basic Widgets', option: EnumMenuOption.basic, icon: Icons.widgets),
    const MenuItem(label: 'Salir', option: EnumMenuOption.salir, icon: Icons.exit_to_app),
  ];

  void select(EnumMenuOption option) {
    selected = option;
    update();
  }
}

enum EnumMenuOption { json, api, camara, imagenes, course, checkbox, basic, columnasRows, sqlite, salir }
class MenuItem {
  final String label;
  final EnumMenuOption option;
  final IconData? icon;

  const MenuItem({required this.label, required this.option, this.icon});
}
