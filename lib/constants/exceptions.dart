
//login exception
class UserNotFoundAuthException implements Exception{}

class WrongPasswordAuthException implements Exception{}

//register exception
class InvalidEmailAuthException implements Exception{}

class EmailAlreadyInUseAuthException implements Exception{}

class WeakPasswordAuthException implements Exception{}

//generic exceptions
class GenericAuthException implements Exception{}

class UserNotLoggedInAuthException implements Exception{}

//data base exception
class DatabaseAlreadyOpenException implements Exception {}

class DatabaseNotOpenException implements Exception {}

class UnableToGetDocumentsDirectoryException implements Exception {}

class CouldNotDeleteUserException implements Exception {}

class CouldNotFoundUserException implements Exception {}

class EmailAlreadyExistException implements Exception {}

class CouldNotDeleteNoteException implements Exception {}

class CouldNotUpdateNoteException implements Exception {}

class CouldNotFoundNoteException implements Exception {}