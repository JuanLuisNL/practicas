import 'package:flutter/material.dart';
import 'menu_option.dart';

class MenuItem {
  final String label;
  final MenuOption option;
  final IconData? icon;

  const MenuItem({required this.label, required this.option, this.icon});
}
