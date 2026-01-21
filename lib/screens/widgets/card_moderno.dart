import 'dart:ui';
import 'package:flutter/material.dart';

/// Card moderno y parametrizable. Mantiene aspecto cuadrado con [AspectRatio]
/// y admite un tamaño mínimo vía [minSize].
class ModernCardWidget extends StatelessWidget {
  final String label;
  final IconData iconData;
  final Color backgroundColor;
  final double elevation;
  final double borderRadius;
  final double minSize;
  final VoidCallback? onTap;
  final bool selected;

  const ModernCardWidget({
    Key? key,
    required this.label,
    required this.iconData,
    this.backgroundColor = Colors.white,
    this.elevation = 6.0,
    this.borderRadius = 12.0,
    this.minSize = 100,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usar `backgroundColor` para crear dos tintas/gradientes diferentes.
    // El controlador ya devuelve colores con alpha; aquí los enriquecemos para glassmorphism.
    final baseTop = backgroundColor.withAlpha((0.22 * 255).round());
    final baseBottom = backgroundColor.withAlpha((0.10 * 255).round());
    final borderColor = Colors.white.withAlpha((0.28 * 255).round());

    // Elegir color de texto/icon según luminancia del background (para contraste)
    final luminance = backgroundColor.computeLuminance();
    final defaultContentColor = luminance > 0.5 ? Colors.black87 : Colors.white70;
    final selectedContentColor = Colors.white;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Blur del fondo (glass effect)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.transparent),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(color: borderColor, width: 1.4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.12 * 255).round()),
                          blurRadius: selected ? 18 : 8,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [baseTop, baseBottom],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: selected ? Colors.white.withAlpha((0.18 * 255).round()) : Colors.white10,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha((0.06 * 255).round()),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(iconData, size: 28, color: selected ? selectedContentColor : defaultContentColor),
                        ),
                        const SizedBox(height: 10),
                        Flexible(
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selected ? selectedContentColor : defaultContentColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
