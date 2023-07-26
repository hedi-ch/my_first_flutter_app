import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/Widget/email_verification_widget.dart';
import 'package:my_first_flutter_app/constants/menu_action.dart';
import 'package:my_first_flutter_app/constants/routes.dart';
import 'package:my_first_flutter_app/view/notes_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verify Email'),
          actions: [
            PopupMenuButton<MenuAction>(//Menu Action is enum defined in the const folder so then popup menu shuld be from menuAction
              itemBuilder: (context) => const [//item builder contene the item desplay in the menu with value and child
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text("Log out")),
              ], 
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(
                        context); //this line will show mode to choose if you wont to log out
                    if (shouldLogout) {
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    }
                    break;
                }
              },
            )
          ],
        ),
        body: emailVerificationWidget(context));
  }
}
