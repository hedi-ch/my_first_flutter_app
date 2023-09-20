import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/constants/routes.dart';
import 'package:my_first_flutter_app/services/auth/auth_service.dart';
import 'package:my_first_flutter_app/view/login_view.dart';
import 'package:my_first_flutter_app/view/note/create_update_note_view.dart';
import 'package:my_first_flutter_app/view/note/notes_view.dart';
import 'package:my_first_flutter_app/view/register_view.dart';
import 'package:my_first_flutter_app/view/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Flutter app',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const Homepage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        newNoteRoute: (context) => const CreateOrUpdateNoteView(),
        mainRoute: (context) => const Homepage(),
      },
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                //devtools.log(user.toString());
                //devtools.log(
                //    'the user is verified ? :=> ${user.emailVerified.toString()}');
                //devtools.log("in the main .dart the log");
                if (user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
