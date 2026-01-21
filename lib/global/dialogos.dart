import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:practicas/global/shortcuts_actions_helper.dart';
import '../screens/widgets/boton_verial.dart';

enum EnumIconMessage { none, info, error, warning, question }
class Dialogos {
  static Future<void> okMessage(String titulo, String texto, {bool lError = false, Widget? richText, EnumIconMessage eIcon = EnumIconMessage.none}) async {
    FocusNode oFocus = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        oFocus.requestFocus();
      } catch (_) {}
    });

    await Get.defaultDialog(
      barrierDismissible: false,
      title: titulo,
      content: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(10),
        color: (lError) ? Colors.blueGrey.shade100 : null,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (eIcon != EnumIconMessage.none) Padding(padding: const EdgeInsets.only(right: 8), child: getIconMessage(eIcon)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [if (richText != null) SizedBox(width: 800, child: richText), SelectableText(texto.trim())]),
              ],
            ),
          ),
        ),
      ),
      confirm: BotonVerialWidget(
        focusNode: oFocus,
        ancho: 100,
        isModalDialog: true,
        onPressed: () {
          Get.back();
        },
        label: "Aceptar",
        backColor: Colors.green.shade50,
      ),
    );
    try {
      oFocus.dispose();
    } catch (_) {}
  }

  static Icon getIconMessage(EnumIconMessage eIcon) {
    IconData? iconData = switch (eIcon) {
      EnumIconMessage.info => Icons.info,
      EnumIconMessage.error => Icons.dangerous_outlined,
      EnumIconMessage.warning => Icons.warning,
      EnumIconMessage.question => CupertinoIcons.question_circle,
      _ => null,
    };
    Color? color = switch (eIcon) {
      EnumIconMessage.info => Colors.green,
      EnumIconMessage.error => Colors.red,
      EnumIconMessage.warning => Colors.orange,
      EnumIconMessage.question => Colors.blue,
      _ => null,
    };
    return Icon(iconData, color: color, size: 50);
  }

  static Future<bool> ynMessage(String titulo, String texto, {Widget? richText, EnumIconMessage eIcon = EnumIconMessage.question, TextStyle? titleStyle}) async {
    final FocusNode acceptFocus = FocusNode();
    titleStyle ??= const TextStyle(fontWeight: FontWeight.bold);
    bool lRet = false;

    lRet =
        await Get.defaultDialog(
          navigatorKey: Get.key,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          barrierDismissible: false,
          title: titulo,
          titleStyle: titleStyle,
          content: FocusScope(
            canRequestFocus: true,
            autofocus: true,
            child: Shortcuts(
              shortcuts: <ShortcutActivator, Intent>{
                SingleActivator(LogicalKeyboardKey.enter, control: true): const ControlEnterIntent(),
                SingleActivator(LogicalKeyboardKey.escape): const EscIntent()},
              child: Actions(
                actions: <Type, Action<Intent>>{
                  ControlEnterIntent: CallbackAction<ControlEnterIntent>(onInvoke: (intent) => Get.back(result: true)),
                  EscIntent: CallbackAction<EscIntent>(onInvoke: (intent) => Get.back(result: false)),
                },
                child: Focus(
                  autofocus: true,
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      // Pedir foco tras el primer frame si el diálogo está abierto
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (Get.isDialogOpen ?? false) {
                          try {
                            acceptFocus.requestFocus();
                          } catch (_) {}
                        }
                      });
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (eIcon != EnumIconMessage.none) Padding(padding: const EdgeInsets.only(right: 8), child: getIconMessage(eIcon)),
                              SingleChildScrollView(
                                child: Container(
                                  constraints: const BoxConstraints(maxHeight: 400),
                                  child: Column(mainAxisSize: MainAxisSize.min, children: [if (richText != null) richText, Text(texto.trim())]),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotonVerialWidget(
                                onPressed: () {
                                  return Get.back(result: true);
                                },
                                focusNode: acceptFocus,
                                isModalDialog: true,
                                label: "Aceptar",
                                backColor: Colors.green.shade50,
                              ),
                              const SizedBox(width: 10),
                              BotonVerialWidget(
                                onPressed: () {
                                  return Get.back(result: false);
                                },
                                isModalDialog: true,
                                label: "Cancelar",
                                backColor: Colors.red.shade50,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          actions: [],
        ) ??
            false;

    // liberar el FocusNode después de cerrar el diálogo
    try {
      acceptFocus.dispose();
    } catch (_) {}

    debugPrint(lRet.toString());
    return lRet;
  }
}
