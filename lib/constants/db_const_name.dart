const dbName = 'notes db';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const noteTable = 'note';
const userTable = 'user';
const createUserTableRequest = '''CREATE TABLE IF NOT EXISTS user 
    (id integer not null ,
    email text unique not null,
    PRIMARY KEY (id AUTOINCREMENT) 
    );
''';
const createNoteTableRequest = '''
CREATE TABLE IF NOT EXISTS note(
  id integer not null,
  user_id integer not null,
  text text not null,
  primary key (id autoincrement),
  foreign key(user_id) references user(id)
  );
''';