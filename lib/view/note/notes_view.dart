import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/utilities/dialogs/show_choisse_dialog.dart';
import 'package:my_first_flutter_app/constants/menu_action.dart';
import 'package:my_first_flutter_app/constants/routes.dart';
import 'package:my_first_flutter_app/services/auth/auth_service.dart';
import 'package:my_first_flutter_app/services/data/data_note_service.dart';

typedef OnTap = void Function(DatabaseNote note);

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Main UI"),
          actions: [
            IconButton(
                onPressed: () async {
                  final bool shouldDeleteNote = await showChoisseDialog(context,
                      title: "Delete All Note",
                      content: "Are you sure you want to delete all note?");
                  if (shouldDeleteNote) {
                    await _noteService.clearNote();
                  }
                },
                icon: const Icon(Icons.cleaning_services)),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showChoisseDialog(
                      context,
                      title: 'Sign out',
                      content: 'Are you sure you want to sign out?',
                    );
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
                        if (snapshot.hasData) {
                          final allNotes = snapshot.data as List<DatabaseNote>;
                          return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: allNotes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(onTap: (){
                                  Navigator.of(context).pushNamed(
                                    newNoteRoute,
                                    arguments: allNotes[index]);},
                                  child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                        top: BorderSide(color: Color(0xFFDFDFDF)),
                                        left:
                                            BorderSide(color: Color(0xFFDFDFDF)),
                                        right:
                                            BorderSide(color: Color(0xFF7F7F7F)),
                                        bottom:
                                            BorderSide(color: Color(0xFF7F7F7F)),
                                      )),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              allNotes[index].text,
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            trailing: IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                ),
                                                onPressed: () async {
                                                  final bool shouldDeleteNote =
                                                      await showChoisseDialog(
                                                          context,
                                                          title: "Delete Note",
                                                          content:
                                                              "Are you sure you want to delete note?");
                                                  if (shouldDeleteNote) {
                                                    await _noteService.deleteNote(
                                                        id: allNotes[index].id);
                                                  }
                                                }),
                                          ),
                                          Container(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 14, 31, 85),
                                                        width: 1))),
                                            child: Text(
                                              textAlign: TextAlign.start,
                                              allNotes[index].text.substring(allNotes[index].text.indexOf("\n")+1),
                                              maxLines: 5,
                                              softWrap: true,
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              });
                        } else {
                          return const CircularProgressIndicator();
                        }

                      case ConnectionState.waiting:
                        return const Text(
                            "Future builder of note stream is waiting");
                    }
                  },
                );
              case ConnectionState.none:
                return const Text("Future builder of note is none");
              case ConnectionState.active:
                return const Text("Future builder of note is active");
              case ConnectionState.waiting:
                return const Text("Future builder of note is waiting");
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(newNoteRoute);
          },
          tooltip: 'add new note',
          child: const Icon(Icons.add),
        ));
  }
}
