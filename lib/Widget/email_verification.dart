import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget emailVerification() =>Column(
      children: [
        const Text("Please verify your email"),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text("Send email verification"),
        )
      ],
    );
    
