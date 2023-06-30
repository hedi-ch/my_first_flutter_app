import 'package:flutter/material.dart';

class DoneView extends StatelessWidget {
  const DoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Done view")),
      body: const Text("Done✨🧨✨"),
    );
  }
}