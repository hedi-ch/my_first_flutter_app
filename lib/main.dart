//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/firebase_options.dart';
import 'package:my_first_flutter_app/view/login_view.dart';
import 'package:my_first_flutter_app/view/register_view.dart';
//import 'package:my_first_flutter_app/view/verify_email_view.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const Homepage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return /*Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
        ),
        body:*/
        FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  /*final user = FirebaseAuth.instance.currentUser;
                  if ((user?.emailVerified ?? false)) {
                    return const Text("Done🎇🎇🎆🎆🎇🎆");
                  }
                  else{
                    return const VerifyEmailView();
                  }*/
                  return const LoginView();

                default:
                  return const CircularProgressIndicator();
              }
            })/*)*/;
  }
}
