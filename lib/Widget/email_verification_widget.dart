import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/constants/routes.dart';

Widget emailVerificationWidget(BuildContext context) => Column(
      children: [
        const Text("Please verify your email"),
        TextButton(
          onPressed: () async {
            final navigator = Navigator.of(context);
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
            await FirebaseAuth.instance.signOut();
            navigator.pushNamedAndRemoveUntil(loginRoute, (_) => false);
          },
          child: const Text("Send email verification"),
        )
      ],
    );
