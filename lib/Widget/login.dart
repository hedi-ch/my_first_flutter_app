import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget login(_email, _password) => Column(
      children: [
        //text field enregister every time change the value in the controller TextEditingController
        //after init and dispo
        TextField(
          controller: _email,
          keyboardType: TextInputType
              .emailAddress, //tell the phone the field for emailadress to change the keybored to suite email
          autocorrect: false,
          enableSuggestions: false,
          decoration: const InputDecoration(hintText: 'Enter your email here'),
        ),
        TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here')),
        TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                final cordation = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                print(cordation);
              } on FirebaseAuthException catch (e) {
                // TODO
                switch (e.code) {
                  case "user-not-found":
                    print("user-not-found");
                    break;
                  case "wrong-password":
                    print("wrong-password");
                    break;
                  default:
                    print("other eror => {${e.code}}");
                }
              }
            },
            child: const Text("Login")),
      ],
    );