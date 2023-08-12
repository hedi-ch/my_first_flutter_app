import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/constants/menu_action.dart';
import 'package:my_first_flutter_app/constants/routes.dart';
import 'package:my_first_flutter_app/services/auth/auth_service.dart';
import 'package:my_first_flutter_app/services/data/data_note_service.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Sign out"),
      content: const Text("Are you sure you want to sign out?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Log out"))
      ],
    ),
  ).then((value) => value ?? false);
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});
  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  //create a geter for the email
  String get userEmail => AuthService.firebase().currentUser!.email!;

  //preaper field for the note service wicth will open on the init state and close on the dispose
  late NoteService _noteService;
  @override
  void initState() {
    //what happen on the create of the state
    _noteService = NoteService();
    _noteService.open();
    super.initState();
  }

  @override
  void dispose() {
    _noteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Main UI"),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      if (!mounted) return;
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text("Log out"),
                  ),
                ];
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: _noteService.getOrCreateUser(email: userEmail),
          builder:
              (BuildContext context, AsyncSnapshot<DatabaseUser> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _noteService.allNoteCash,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DatabaseNote>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return const Text(
                            "Future builder of note stream is done");
                      case ConnectionState.none:
                        return const Text(
                            "Future builder of note stream is none");
                      case ConnectionState.active:
                        return const Text(
                            "Future builder of note stream is active");
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              case ConnectionState.none:
                return const Text("Future builder of note is none");
              case ConnectionState.active:
                return const Text("Future builder of note is active");
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
