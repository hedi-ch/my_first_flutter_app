import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/services/auth/auth_service.dart';
import 'package:my_first_flutter_app/services/data/data_note_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NoteService _noteService;
  late final TextEditingController _textController;

  Future<DatabaseNote> getOrCreateNote() async {
    final existNote = _note;
    if (existNote != null) {
      return existNote;
    } else {
      final currentUserEmail = AuthService.firebase().currentUser!.email!;
      final owner = await _noteService.getUser(email: currentUserEmail);
      return await _noteService.addNote(text: "fdg", owner: owner);
    }
  }

  void _deleteTextIfEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _noteService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfEmpty() {
    final note = _note;
    final text = _textController.text;
    if (_textController.text.isNotEmpty && note != null) {
      _noteService.updateNote(id: note.id, text: text);
    }
  }

  void _textControllerListener() async {
    final note = _note;
    final text = _textController.text;
    if (note != null) {
      await _noteService.updateNote(id: note.id, text: text);
    }
  }

  void _stupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _noteService = NoteService();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteTextIfEmpty();
    _saveNoteIfEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New note"),
      ),
      body: FutureBuilder(
          future: getOrCreateNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.data as DatabaseNote;
                _stupTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines:
                      null, //tell the phone the field for emailadress to change the keybored to suite email
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(hintText: 'Your note ...'),
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
