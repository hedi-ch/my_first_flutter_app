import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/services/auth/auth_service.dart';
import 'package:my_first_flutter_app/services/data/data_note_service.dart';
import 'package:my_first_flutter_app/utilities/generic/get_arguments.dart';

class CreateOrUpdateNoteView extends StatefulWidget {
  const CreateOrUpdateNoteView({super.key});

  @override
  State<CreateOrUpdateNoteView> createState() => _CreateOrUpdateNoteViewState();
}

class _CreateOrUpdateNoteViewState extends State<CreateOrUpdateNoteView> {
  DatabaseNote? _note;
  late final NoteService _noteService;
  late final TextEditingController _textController;

  Future<DatabaseNote> getOrCreateNote() async {
    final existNote = context.getArguments<DatabaseNote>() ?? _note;
    if (existNote != null) {
      _textController.text = existNote.text;
      return existNote;
    } else {
      final currentUserEmail = AuthService.firebase().currentUser!.email!;
      final owner = await _noteService.getUser(email: currentUserEmail);
      final newNote = await _noteService.addNote(text: "", owner: owner);
      _note = newNote;
      return newNote;
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
                _stupTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines:
                      null, //tell the phone the field for email address to change the keyboarded to suite email
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
