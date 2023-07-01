import 'package:flutter/material.dart';

Widget notesWidget() =>Column(
      children: [
        const Text("Please verify your email"),
        TextButton(
          onPressed: ()  {
          },
          child: const Text("there is your Note"),
        )
      ],
    );