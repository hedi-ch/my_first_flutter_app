import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/utilities/dialogs/show_generic_dialog.dart';

Future<bool> showChoisseDialog(BuildContext context,
    {required String title, required String content}) {
  return showGenericDialog(
    context: context,
    title: title,
    content: content,
    optionBuilder: () => {
      "Cancel": false,
      "Contenue": true,
    },
  ).then((value) => value ?? false);
}
