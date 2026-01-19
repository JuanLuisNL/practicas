import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'menu_option.dart';
import 'menu_item.dart';
import 'package:flutter/material.dart';

class MenuPracticasController extends GetxController {
  MenuOption selected = MenuOption.json;

  final items = <MenuItem>[
    const MenuItem(label: 'Leer Json de Assets', option: MenuOption.json, icon: Icons.file_present),
    const MenuItem(label: 'Llamar a un API', option: MenuOption.api, icon: Icons.api),
    const MenuItem(label: 'Cámara', option: MenuOption.camara, icon: Icons.camera_alt),
    const MenuItem(label: 'Imágenes', option: MenuOption.imagenes, icon: Icons.image),
    const MenuItem(label: 'Curso (estructura)', option: MenuOption.course, icon: Icons.school),
    const MenuItem(label: 'Checkbox (ejemplo)', option: MenuOption.checkbox, icon: Icons.check_box),
  ];

  void select(MenuOption option) {
    selected = option;
    update();
  }
}
