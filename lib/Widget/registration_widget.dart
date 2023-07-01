import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget registrationWidget(TextEditingController userEmail,
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
                final cordation = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                print(cordation);
              } //on Exception catch (e) {
              //this is how to know the type of the Exception
              //print(e.runtimeType);
              //}
              on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case "weak-password":
                    print("passord is weakl");
                    break;
                  case "email-already-in-use":
                    print("email is already in use");
                    break;
                  case "invalid-email":
                    print("The email address is badly formatted");
                    break;
                  default:
                    print(e.code);
                }
              }
            },
            child: const Text("Register")),
        TextButton(
            onPressed: () {
              //change the view
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login/', (route) => false);
            },
            child: const Text("Already have acount ?Login here!✨✨"))
      ],
    );
