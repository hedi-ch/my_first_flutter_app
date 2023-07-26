import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String errorText,
) =>
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("errorText"),
              content: Text(errorText),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"))
              ],
            ));