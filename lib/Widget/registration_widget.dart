import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/Widget/show_done_dialog_widget.dart';
import 'package:my_first_flutter_app/Widget/show_error_dialog_widget.dart';
import 'package:my_first_flutter_app/constants/routes.dart';

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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, password: password);
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                // ignore: use_build_context_synchronously
                await showDoneDialog(
                    context,
                    "we send email verification all ready pls verify it ",
                    loginRoute);
                //devtools.log(cordation.toString());
              } //on Exception catch (e) {
              //this is how to know the type of the Exception
              //devtools.log(e.runtimeType);
              //}
              on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case "weak-password":
                    await showErrorDialog(context, "passord is weakl");
                    break;
                  case "email-already-in-use":
                    await showErrorDialog(context, "email is already in use");
                    break;
                  case "invalid-email":
                    await showErrorDialog(
                        context, "The email address is badly formatted");
                    break;
                  default:
                    await showErrorDialog(context, e.code);
                }
              }
            },
            child: const Text("Register")),
        TextButton(
            onPressed: () {
              //change the view
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Already have acount ?Login here!✨✨"))
      ],
    );
