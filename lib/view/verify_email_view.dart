import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/Widget/email_verification_widget.dart';
import 'package:my_first_flutter_app/utilities/dialogs/show_choisse_dialog.dart';
import 'package:my_first_flutter_app/constants/menu_action.dart';
import 'package:my_first_flutter_app/constants/routes.dart';
import 'package:my_first_flutter_app/services/auth/auth_service.dart';
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
                    final shouldLogout = await showChoisseDialog(
                        context, title: 'Sign out', content: 'Are you sure you want to sign out?',); //this line will show mode to choose if you wont to log out
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
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
