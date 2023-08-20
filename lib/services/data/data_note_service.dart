import 'dart:async' show StreamController;
import 'package:my_first_flutter_app/constants/db_const_name.dart';
import 'package:my_first_flutter_app/constants/exceptions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NoteService {
  Database? _db;
//stream of note cashe
  List<DatabaseNote> _notes = [];
// stream controller
  late final StreamController<List<DatabaseNote>> _noteStreamController;

  //make note service singleton
  static final NoteService _shared = NoteService._sharedInstance();
  NoteService._sharedInstance() {
    _noteStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _noteStreamController.sink.add(_notes);
      },
    );
  }
  factory NoteService() => _shared;

  Stream<List<DatabaseNote>> get allNoteCash => _noteStreamController.stream;
// cash note
  Future<void> _cashNotes() async {
    final allNotes = await getNote();
    _notes = allNotes.toList();
    _noteStreamController.add(_notes);
  }

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFoundUserException {
      final user = await addUser(email: email);
      return user;
    } catch (_) {
      rethrow;
    }
  }

//if this function don't work look at 1:37:22 => https://www.youtube.com/watch?v=IXNjoByIX5Y&list=PL6yRaaP0WPkVtoeNIGqILtRAgd3h2CNpT&index=28
// and rewrite the code of get note and get all note;
  Future<DatabaseNote> updateNote({
    required int id,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrowException();
    await getNote(id);
    final updateList = await db.rawQuery(
        "update $noteTable set $textColumn = ' $text g' where $idColumn =$id");
    if (updateList.isEmpty) {
      throw CouldNotUpdateNoteException();
    } else {
      final note = DatabaseNote.fromRow(updateList[0]);
      _notes.removeWhere((elementNote) => elementNote.id == id);
      _notes.add(note);
      _noteStreamController.add(_notes);
      return note;
    }
  }

  Future<Iterable<DatabaseNote>> getNote([int? id]) async {
    await _ensureDbIsOpen();
    //if you pass id you will get the note with that id
    // if you pass is without id will return all the notes
    final db = _getDatabaseOrThrowException();
    if (id == null) {
      final notes = await db.rawQuery("select * from $noteTable");
      final noteIterable =
          notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
      _notes = noteIterable.toList();
      _noteStreamController.add(_notes);
      return noteIterable;
    } else {
      final notes =
          await db.rawQuery("select * from $noteTable where $idColumn = $id");
      if (notes.isNotEmpty) {
        final noteIterable =
            notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
        final note = noteIterable.first;
        _notes.removeWhere((noteElement) => noteElement.id == id);
        _notes.add(note);
        _noteStreamController.add(_notes);
        return noteIterable;
      } else {
        throw CouldNotFoundNoteException();
      }
    }
  }

  Future<int> clearNote() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrowException();
    final deleleteCount = await db.delete(noteTable);
    final numberOfDelet = deleleteCount;
    if (numberOfDelet != 0) {
      _notes.clear();
      _noteStreamController.add(_notes);
    }
    return numberOfDelet;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrowException();
    final deleleteCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deleleteCount != 1) {
      throw CouldNotDeleteNoteException();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _noteStreamController.add(_notes);
    }
  }

  Future<DatabaseNote> addNote(
      {required String text, required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrowException();
    final user = await getUser(email: owner.email);
    if (user == owner) {
      final noteId = await db
          .insert(noteTable, {userIdColumn: owner.id, textColumn: text});
      final note = DatabaseNote.fromRow(
          {idColumn: noteId, userIdColumn: owner.id, textColumn: text});
      _notes.add(note);
      _noteStreamController.add(_notes);
      return note;
    } else {
      throw CouldNotFoundUserException();
    }
  }

  Database _getDatabaseOrThrowException() {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
      // ignore: empty_catches
    } on DatabaseAlreadyOpenException {}
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrowException();
    final users = await db.query(userTable,
        columns: [idColumn, emailColumn],
        where: '$emailColumn = ?',
        whereArgs: [email.toLowerCase()]);
    if (users.isNotEmpty) {
      final user = users[0];
      return DatabaseUser.fromRow(user);
    } else {
      throw CouldNotFoundUserException();
    }
  }

  Future<DatabaseUser> addUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrowException();
    final users = await db.query(userTable,
        columns: [idColumn],
        where: '$emailColumn = ?',
        whereArgs: [email.toLowerCase()]);
    if (users.isNotEmpty) {
      throw EmailAlreadyExistException();
    } else {
      final userId =
          await db.insert(userTable, {emailColumn: email.toLowerCase()});
      return DatabaseUser(id: userId, email: email);
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrowException();
    final deleleteCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deleleteCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      //create note and user table
      await db.execute(createUserTableRequest);
      await db.execute(createNoteTableRequest);

      //cash the note when you the db
      await _cashNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }
}

class DatabaseUser {
  final int id;
  final String email;
  DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() {
    return 'the user id:"$id" have email :"$email"';
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  DatabaseNote({required this.userId, required this.id, required this.text});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String;

  @override
  String toString() {
    return 'the note id:"$id" have text :"$text" and it from user id :"$userId"';
  }

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
