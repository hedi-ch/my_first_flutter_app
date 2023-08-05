import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/Widget/show_error_dialog_widget.dart';
import 'package:my_first_flutter_app/constants/exceptions.dart';
import 'package:my_first_flutter_app/constants/routes.dart';
import 'package:my_first_flutter_app/services/auth/auth_service.dart';

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
                await AuthService.firebase()
                    .logIn(email: email, password: password);
                navigator.pushNamedAndRemoveUntil(mainRoute, (_) => false);
              } on UserNotFoundAuthException {
                await showErrorDialog(context, "user not found");
              } on WrongPasswordAuthException {
                await showErrorDialog(
                    context, "pls make shure if the password is correct");
              } on InvalidEmailAuthException {
                await showErrorDialog(
                    context, "the forma of the email is rong");
              } on GenericAuthException {
                await showErrorDialog(context, "Authentification error");
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
