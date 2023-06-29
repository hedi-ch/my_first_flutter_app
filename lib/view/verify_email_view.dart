import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/Widget/login.dart';
import 'package:my_first_flutter_app/view/login_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Please verify your email"),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
            print(user);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginView()));
          },
          child: const Text("Send email verification"),
        )
      ],
    );
  }
}
