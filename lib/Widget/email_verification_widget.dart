import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/constants/routes.dart';
import 'package:my_first_flutter_app/services/auth/auth_service.dart';

Widget emailVerificationWidget(BuildContext context) => Column(
      children: [
        const Text("Please verify your email"),
        TextButton(
          onPressed: () async {
            final navigator = Navigator.of(context);
            await AuthService.firebase().sendEmailVerification();
            await  AuthService.firebase().logOut();
            navigator.pushNamedAndRemoveUntil(loginRoute, (_) => false);
          },
          child: const Text("Send email verification"),
        )
      ],
    );
