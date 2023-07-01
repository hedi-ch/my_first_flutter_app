import 'package:flutter/material.dart';

Widget notesWidget() =>Column(
      children: [
        const Text("Main page"),
        TextButton(
          onPressed: ()  {
          },
          child: const Text("there is your Note"),
        )
      ],
    );