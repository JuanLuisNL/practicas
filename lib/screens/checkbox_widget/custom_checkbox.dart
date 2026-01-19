import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Checkbox personalizado que muestra un label reactivo mediante ValueListenable
class CustomCheckbox extends StatefulWidget {
  /// La etiqueta se actualiza automáticamente cuando cambia el valor del notifier
  final ValueListenable<String> labelNotifier;

  /// Estado inicial del checkbox
  final bool initialValue;

  /// Callback cuando cambia el valor
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox({
    super.key,
    required this.labelNotifier,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.initialValue;
  }

  void _toggle() {
    setState(() {
      _checked = !_checked;
    });
    widget.onChanged?.call(_checked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggle,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(value: _checked, onChanged: (v) => _toggle()),
            const SizedBox(width: 8),
            ValueListenableBuilder<String>(
              valueListenable: widget.labelNotifier,
              builder: (context, label, _) {
                return Text(label, style: Theme.of(context).textTheme.bodyLarge);
              },
            ),
          ],
        ),
      ),
    );
  }
}
