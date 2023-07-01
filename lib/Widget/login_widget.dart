import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

Widget loginWidget(TextEditingController userEmail,
        TextEditingController userPassword, BuildContext context) =>
    Column(
      children: [
        //text field enregister every time change the value in the controller TextEditingController
        //after init and dispo
        TextField(
          controller: userEmail,
          keyboardType: TextInputType
              .emailAddress, //tell the phone the field for emailadress to change the keybored to suite email
          autocorrect: false,
          enableSuggestions: false,
          decoration: const InputDecoration(hintText: 'Enter your email here'),
        ),
        TextField(
            controller: userPassword,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here')),
        TextButton(
            onPressed: () async {
              final email = userEmail.text;
              final password = userPassword.text;

              try {
                final navigator = Navigator.of(context);
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                navigator.pushNamedAndRemoveUntil('/Notes/', (_) => false);
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case "user-not-found":
                    devtools.log("user-not-found");
                    break;
                  case "wrong-password":
                    devtools.log("wrong-password");
                    break;
                  default:
                    devtools.log("other eror => {${e.code}}");
                }
              }
            },
            child: const Text("Login")),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: const Text("Don't have acount yet ? Register here!"))
      ],
    );
