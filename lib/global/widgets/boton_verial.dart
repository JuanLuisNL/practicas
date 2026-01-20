
import 'package:flutter/material.dart';

class BotonVerialWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double ancho;
  final Color backColor;
  final FocusNode? focusNode;
  final bool isModalDialog;
  final Icon? icon;

  const BotonVerialWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.ancho = 150,
    this.backColor = Colors.white,
    this.focusNode,
    this.isModalDialog = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: ancho, maxWidth: ancho),
        child: ElevatedButton(
          focusNode: focusNode,
          style: ElevatedButton.styleFrom(
            backgroundColor: backColor,
          ),
          onPressed: onPressed,
          child: icon != null
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon!,
              const SizedBox(width: 8),
              Text(label),
            ],
          )
              : Text(label),
        ),
      ),
    );
  }
}