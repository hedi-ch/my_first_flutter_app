import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/utilities/dialogs/show_generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String errorText,
) =>
    showGenericDialog(
      context: context,
      title: "errorText",
      content: errorText,
      optionBuilder: () => {
        'OK': null,
      },
    );
