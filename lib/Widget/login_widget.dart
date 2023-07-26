import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/Widget/show_error_dialog_widget.dart';

import 'package:my_first_flutter_app/constants/routes.dart';

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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);
                navigator.pushNamedAndRemoveUntil(mainRoute, (_) => false);
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case "user-not-found":
                    await showErrorDialog(context, "user not found");
                    break;
                  case "wrong-password":
                    await showErrorDialog(
                        context, "pls make shure if the password is correct");
                    break;
                  case "invalid-email":
                    await showErrorDialog(
                        context, "the forma of the email is rong");
                    break;
                  default:
                    await showErrorDialog(context, "other eror => {${e.code}}");
                }
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text("Login")),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Don't have acount yet ? Register here!"))
      ],
    );
