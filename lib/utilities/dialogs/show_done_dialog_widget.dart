import 'package:flutter/material.dart';

Future<void> showDoneDialog(BuildContext context, String centent,
        [String? root]) =>
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Donne"),
              content: Text(centent),
              actions: [
                TextButton(
                    onPressed: () {
                      if (root != null) {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(root, (route) => false);
                      }
                      else{
                        Navigator.of(context).pop();
                      }
                      
                    },
                    child: const Text("OK"))
              ],
            ));
