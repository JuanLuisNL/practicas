import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/material.dart';

import '../../menu/menu_controller.dart';

class MenuBasicController extends GetxController {
  EnumMenuOption selected = EnumMenuOption.json;

  final lstItems = <MenuItem>[
    const MenuItem(label: 'Columnas y filas', option: EnumMenuOption.columnasRows, icon: Icons.grid_view),
    const MenuItem(label: 'SQL lite', option: EnumMenuOption.sqlite, icon: Icons.storage),
    const MenuItem(label: 'Salir', option: EnumMenuOption.salir, icon: Icons.exit_to_app),
  ];

  void select(EnumMenuOption option) {
    selected = option;
    update();
  }
}
