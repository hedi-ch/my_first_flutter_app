import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget login(userEmail, userPassword) => Column(
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
